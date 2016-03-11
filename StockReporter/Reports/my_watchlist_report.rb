require_relative '../Queries/equity_queries'
require_relative '../Calculators/relative_strength_analyzer'
require_relative '../Calculators/movement_calculator'
require_relative '../Queries/day_movement_query'
require_relative '../Queries/company_instrument_query'
require_relative '../Queries/watchlist_query'
require 'time_diff'

class MyWatchlistReport

  def initialize
    @watchlist_query = WatchlistQuery.new
  end

  def generate(date, user_id)
    calculate_movement_days(date)

    day_movement_query = DayMovementQuery.new

    @my_watchlist = @watchlist_query.query(user_id).to_a
    puts "Watchlist #{@my_watchlist}"

    return [] if @my_watchlist.empty?

    @company_instrument_query = CompanyInstrumentQuery.new

    my_watchlist = @my_watchlist
      .select{|e| e["DateAdded"] <= date}
      .to_a

    equity_share_names = my_watchlist .map{|e| e["ShareIndex"]}.to_a

    equities = day_movement_query.query(equity_share_names, date)

    rows = get_rows(my_watchlist , equities, date)

    return rows
  end

  private

  def get_rows(my_watchlist, equities, date)

      transactions = get_transactions(my_watchlist,equities,date)

      return [] if transactions.count == 0

      return transactions
  end

  #def get_my_watchlist(transactions)
      #my_equities = Array.new

      #equities = transactions.group_by{|e| e["ShareIndex"]}

      #equities.each{|key,transactions| 
        #equity = OpenStruct.new
        #equity.ShareIndex = key
        #equity.ShareName = transactions[0].ShareName
        #equity.DateOfPrice = transactions[0].DateOfPrice
        #equity.Volume = transactions[0].Volume
        #equity.PeRatio = transactions[0].PeRatio
        #equity.ClosePrice = transactions[0].ClosePrice
        #equity.DailyMovement = transactions[0].DailyMovement
        #equity.FiveYearGrowth = transactions[0].FiveYearGrowth
        #equity.ThreeYearGrowth = transactions[0].ThreeYearGrowth
        #equity.FiftyTwoWkGrowth = transactions[0].FiftyTwoWkGrowth
        #equity.SixMonthGrowth = transactions[0].SixMonthGrowth
        #equity.FourWkGrowth = transactions[0].FourWkGrowth
        #equity.RelativeStrength = transactions[0].RelativeStrength
        #equity.Sector = transactions[0].Sector
        #equity.Industry = transactions[0].Industry
        #equity.NoOfShares = transactions.map{|t| t.NoOfShares }.inject(:+).round(4)
        #equity.PurchaseValue = calculate_share_purchase_price_from_transactions(transactions).round(2)
        #equity.CurrentValue = transactions.map{|t| t.CurrentValue }.inject(:+).round(2)
        #equity.TotalMovement = ((equity.CurrentValue / equity.PurchaseValue - 1) * 100).round(2)
        #equity.DaysHeld = transactions.max{|a,b| a.DaysHeld <=> b.DaysHeld }.DaysHeld
        #equity.DailyAverage = (equity.TotalMovement / equity.DaysHeld).round(2)

        #my_equities << equity
      #}

      #return my_equities

  #end

  def get_transactions(my_watchlist, equities, date)

      rows = Array.new

      my_watchlist.each do |my_watchlist|

        equity = equities.select{|e| e["ShareIndex"] == my_watchlist["ShareIndex"]}.first

        next if equity.nil?

        equity = populate_indicators(my_watchlist,equity,date)

        row = OpenStruct.new

        row.ShareIndex = equity["ShareIndex"]
        row.ShareName = equity["ShareName"]
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
        row.MyWatchlistId = my_watchlist["_id"].to_s
        row.DateAdded = my_watchlist["DateAdded"]
        row.Price = my_watchlist["Price"]

        rows.push(row)
      end
      return rows
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

  def populate_indicators(my_watchlist_share, equity, date)
    relative_strength_analyzer = RelativeStrengthAnalyzer.new
    movement_calculator = MovementCalculator.new
    share_index = my_watchlist_share["ShareIndex"]
    baseline = "DBXUS"
    date_added = my_watchlist_share["DateAdded"] 

    equity["RelativeStrength"] = relative_strength_analyzer.compare_for_day(share_index,baseline, date).round(2)
    equity["DailyMovement"] = movement_calculator.business_day_movement(share_index, date)
    equity["FiveYearGrowth"] = movement_calculator.movement_between_days(share_index, date, @two_hundred_sixty_days_ago)
    equity["ThreeYearGrowth"] = movement_calculator.movement_between_days(share_index, date,  @hundred_fifty_six_days_ago)
    equity["FiftyTwoWkGrowth"] = movement_calculator.movement_between_days(share_index, date, @fifty_two_days_ago)
    equity["SixMonthGrowth"] = movement_calculator.movement_between_days(share_index, date, @twenty_six_days_ago)
    equity["FourWkGrowth"] = movement_calculator.movement_between_days(share_index, date, @four_weeks_ago)
    equity["DaysHeld"] = get_days_held(date, date_added)
    equity["TotalMovement"] = movement_calculator.movement_between_days(share_index,  date, date_added)

    company = @company_instrument_query.find_one(share_index)

    puts "company #{company}"
    
    if !company.nil?
      equity["Sector"] = company["Sector"]
      equity["Industry"] = company["Industry"]
      equity["ShareName"] = company["CompanyName"]
    end

    return equity
  end

  def get_days_held(date, date_added)
    Time.diff(date_added, date, '%d')[:diff].gsub(' days','').to_i
  end

end
