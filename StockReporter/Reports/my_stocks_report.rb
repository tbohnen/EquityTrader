require_relative '../Queries/equity_queries'
require_relative '../Queries/day_movement_query'
require_relative '../Queries/company_instrument_query'
require_relative '../Queries/stock_technical_analysis_query'
require_relative '../Calculators/movement_calculator.rb'
require 'logger'

class MyStocksReport

  def initialize
    @equities = EquityQueries.new
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG

  end

  def generate(date, user_id)
    calculate_movement_days(date)

    day_movement_query = DayMovementQuery.new

    @my_equities = @equities.get_my_shares(user_id).to_a

    return [] if @my_equities.empty?

    @company_instrument_query = CompanyInstrumentQuery.new
    @stock_technical_analysis_query = StockTechnicalAnalysisQuery.new

    my_equities = @my_equities
      .select{|e| e["DateOfPurchase"] <= date}
      .to_a

    equity_share_names = my_equities.map{|e| e["ShareIndex"]}.to_a

    equities = day_movement_query.query(equity_share_names, date)

    rows = get_rows(my_equities, equities, date)

    return rows
  end

  private

  def get_rows(my_equities, equities, date)

      transactions = get_transactions(my_equities,equities,date)

      return [] if transactions.count == 0

      my_equities = get_my_equities(transactions)

      set_my_equities_percentage_of_portfolio(my_equities)

      return my_equities
  end

  def set_my_equities_percentage_of_portfolio(my_equities)
      portfolio_total_value = my_equities.map{|e| e.CurrentValue}.inject(:+).round(2)

      my_equities.each{|e| 
        e.PercentageOfPortfolio = (e.CurrentValue / portfolio_total_value * 100).round(2)
      }
  end

  def get_my_equities(transactions)
      my_equities = Array.new

      equities = transactions.group_by{|e| e.ShareIndex }

      equities.each{|key,transactions| 

        equity = OpenStruct.new
        equity.ShareIndex = key
        equity.ShareName = transactions[0].ShareName
        equity.PortfolioName = transactions.last.PortfolioName
        equity.DateOfPrice = transactions[0].DateOfPrice
        equity.Volume = transactions[0].Volume
        equity.PeRatio = transactions[0].PeRatio
        equity.ClosePrice = transactions[0].ClosePrice.to_f
        equity.DailyMovement = transactions[0].DailyMovement
        equity.FiveYearGrowth = transactions[0].FiveYearGrowth
        equity.ThreeYearGrowth = transactions[0].ThreeYearGrowth
        equity.FiftyTwoWkGrowth = transactions[0].FiftyTwoWkGrowth
        equity.SixMonthGrowth = transactions[0].SixMonthGrowth
        equity.FourWkGrowth = transactions[0].FourWkGrowth
        equity.RelativeStrength = transactions[0].RelativeStrength
        equity.Sector = transactions[0].Sector
        equity.Industry = transactions[0].Industry
        equity.NoOfShares = transactions.map{|t| t.NoOfShares }.inject(:+).round(4)
        equity.PurchaseValue = calculate_share_purchase_price_from_transactions(transactions).round(2)
        equity.CurrentValue = ((equity.ClosePrice * equity.NoOfShares) / 100).round(2)
        equity.CurrentValueOld = transactions.map{|t| t.CurrentValue }.inject(:+).round(2)
        equity.TotalMovement = ((equity.CurrentValue / equity.PurchaseValue - 1) * 100).round(2)
        equity.DaysHeld = transactions.max{|a,b| a.DaysHeld <=> b.DaysHeld }.DaysHeld
        equity.DailyAverage = (equity.TotalMovement / equity.DaysHeld).round(2)

        my_equities << equity if equity.NoOfShares > 0
      }

      return my_equities

  end

  def get_transactions(my_equities, equities, date)

      rows = Array.new

      my_equities.each do |my_equity|

        equity = equities.select{|e| e["ShareIndex"] == my_equity["ShareIndex"]}.first

        next if equity.nil?

        equity = populate_indicators(my_equity,equity,date)

        row = OpenStruct.new

        row.ShareIndex = equity["ShareIndex"]
        row.ShareName = equity["ShareName"]
        row.PortfolioName = my_equity["PortfolioName"]
        row.DateOfPrice = equity["DateOfPrice"]
        row.Volume = equity["Volume"]
        row.PeRatio = equity["PeRatio"]
        row.ClosePrice = equity["ClosePrice"]
        row.DailyMovement = equity["DailyMovement"]
        row.FiveYearGrowth = equity["FiveYearGrowth"]
        row.ThreeYearGrowth = equity["ThreeYearGrowth"]
        row.FiftyTwoWkGrowth = equity["FiftyTwoWkGrowth"]
        row.SixMonthGrowth = equity["SixMonthGrowth"]
        row.FourWkGrowth = equity["FourWkGrowth"]
        row.RelativeStrength = equity["RelativeStrength"]
        row.Sector = equity["Sector"]
        row.Industry = equity["Industry"]
        row.DaysHeld = equity["DaysHeld"]
        row.TotalMovement = equity["TotalMovement"]
        row.NoOfShares = my_equity["NoOfShares"].to_f
        row.CurrentValue = equity["CurrentValue"]
        row.PurchaseValue = equity["PurchaseValue"]
        row.MyEquitiesId = my_equity["_id"].to_s
        row.DateOfPurchase = my_equity["DateOfPurchase"]
        row.PurchasePrice = my_equity["PurchasePrice"]

        rows.push(row)
      end
      return rows
  end

  def calculate_share_purchase_price_from_transactions(transactions)
    sorted_transactions = transactions.sort_by{|t| t.DateOfPurchase}

    for x in 0..sorted_transactions.length - 1 do
      if sorted_transactions[x].NoOfShares < 0
        for y in 0..sorted_transactions.length - 1 do
          if sorted_transactions[y].NoOfShares > --sorted_transactions[x].NoOfShares
            sorted_transactions[y].NoOfShares = sorted_transactions[y].NoOfShares + sorted_transactions[x].NoOfShares
            sorted_transactions[x].NoOfShares = 0
          end
        end
      end
    end

    return sorted_transactions.map{|t| t.NoOfShares * t.PurchasePrice / 100 }.inject(:+)
  end

  def calculate_movement_days(date_from)
    @two_hundred_sixty_days_ago = business_day_before(date_from, 260 )
    @hundred_fifty_six_days_ago = business_day_before(date_from, 156)
    @fifty_two_days_ago = business_day_before(date_from, 52)
    @twenty_six_days_ago = business_day_before(date_from, 26)
    @four_weeks_ago = business_day_before(date_from, 4)
  end

  def remove_days(time, n_days)
    t2 = time - (n_days * 86400)
    utc_delta = time.utc_offset - t2.utc_offset
    (utc_delta == 0) ? t2 : t2 + utc_delta
    return t2
  end

  def business_day_before(date, days)
    new_date = remove_days(date, (days * 7))
    while new_date.wday == 0 || new_date.wday == 6
      new_date = remove_days(new_date, 1)
    end
    return new_date
  end

  def populate_indicators(my_equity, equity, date)
    movement_calculator = MovementCalculator.new
    share_index = equity["ShareIndex"]
    date_of_purchase = my_equity["DateOfPurchase"] 

    technical_analysis = @stock_technical_analysis_query.query(share_index, date)

    if !technical_analysis.nil?
      begin
        equity["DailyMovement"] = technical_analysis["DailyMovement"]
        equity["FiveYearGrowth"] = technical_analysis["FiveYearGrowth"]
        equity["ThreeYearGrowth"] = technical_analysis["ThreeYearGrowth"]
        equity["FiftyTwoWkGrowth"] = technical_analysis["OneYearGrowth"]
        equity["SixMonthGrowth"] = technical_analysis["SixMonthGrowth"]
        equity["FourWkGrowth"] = technical_analysis["FourWkGrowth"]
      rescue
        puts "Error retrieving technical analysis for #{share_index}"
      end
    end

    equity["DaysHeld"] = get_days_held(date, date_of_purchase)

    equity["TotalMovement"] = movement_calculator.movement_between_days(share_index,  date, date_of_purchase)

    company = @company_instrument_query.find_one(share_index)

    if !company.nil?
      equity["Sector"] = company["Sector"]
      equity["Industry"] = company["Industry"]

      equity["ShareName"] = company["ShortName"] if !company["ShortName"].nil?
      equity["ShareName"] = company["CompanyName"] if !company["ShareName"].nil?
    end

    if (my_equity["NoOfShares"] < 0)
      equity["CurrentValue"] =  --((my_equity["NoOfShares"].to_f * my_equity["PurchasePrice"].to_f)/100).round(2)
    else
      equity["CurrentValue"] = ((my_equity["NoOfShares"].to_f * equity["ClosePrice"].to_f)/100).round(2)
    end

    equity["PurchaseValue"] = ((my_equity["NoOfShares"].to_f * my_equity["PurchasePrice"].to_f)/100).round(2)

    return equity
  end

  def get_days_held(date, date_of_purchase)
    ((date - date_of_purchase) / 86400).round(0)
  end

end
