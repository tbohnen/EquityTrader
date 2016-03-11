require_relative '../Queries/equity_queries'
require_relative '../Calculators/relative_strength_analyzer'
require_relative '../Calculators/movement_calculator'
require_relative '../Queries/day_movement_query'
require_relative '../Queries/company_instrument_query'
require 'time_diff'

class MyTransactionsReport

  def initialize
    @equities = EquityQueries.new
  end

  def generate(date, user_id)
    calculate_movement_days(date)

    day_movement_query = DayMovementQuery.new

    @my_equities = @equities.get_my_shares(user_id).to_a

    return [] if @my_equities.empty?

    @company_instrument_query = CompanyInstrumentQuery.new

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

      return transactions
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
        row.DateOfPurchase = my_equity["DateOfPurchase"]
        row.PurchasePrice = my_equity["PurchasePrice"]
        row.TransactionId = my_equity["_id"].to_s

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
    relative_strength_analyzer = RelativeStrengthAnalyzer.new
    movement_calculator = MovementCalculator.new
    share_index = equity["ShareIndex"]
    baseline = "DBXUS"
    date_of_purchase = my_equity["DateOfPurchase"] 

    equity["RelativeStrength"] = relative_strength_analyzer.compare_for_day(share_index,baseline, date).round(2)
    equity["DailyMovement"] = movement_calculator.business_day_movement(share_index, date)
    equity["FiveYearGrowth"] = movement_calculator.movement_between_days(share_index, date, @two_hundred_sixty_days_ago)
    equity["ThreeYearGrowth"] = movement_calculator.movement_between_days(share_index, date,  @hundred_fifty_six_days_ago)
    equity["FiftyTwoWkGrowth"] = movement_calculator.movement_between_days(share_index, date, @fifty_two_days_ago)
    equity["SixMonthGrowth"] = movement_calculator.movement_between_days(share_index, date, @twenty_six_days_ago)
    equity["FourWkGrowth"] = movement_calculator.movement_between_days(share_index, date, @four_weeks_ago)
    equity["DaysHeld"] = get_days_held(date, date_of_purchase)
    equity["TotalMovement"] = movement_calculator.movement_between_days(share_index,  date, date_of_purchase)
    equity["Sector"] = @company_instrument_query.find_one(share_index)["Sector"]
    equity["Industry"] = @company_instrument_query.find_one(share_index)["Industry"]

    if (my_equity["NoOfShares"] < 0)
      equity["CurrentValue"] =  --((my_equity["NoOfShares"].to_f * my_equity["PurchasePrice"].to_f)/100).round(2)
    else
      equity["CurrentValue"] = ((my_equity["NoOfShares"].to_f * equity["ClosePrice"].to_f)/100).round(2)
    end

    equity["PurchaseValue"] = ((my_equity["NoOfShares"].to_f * my_equity["PurchasePrice"].to_f)/100).round(2)

    return equity
  end

  def get_days_held(date, date_of_purchase)
    Time.diff(date_of_purchase, date, '%d')[:diff].gsub(' days','').to_i
  end

end
