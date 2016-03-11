require_relative '../Queries/equity_queries'
require_relative '../Calculators/relative_strength_analyzer'
require_relative '../Calculators/movement_calculator'
require_relative '../Queries/company_instrument_query'

class SectorBestReport

  def initialize(equities)
    @equities = equities
    @company_instrument_query = CompanyInstrumentQuery.new
  end

  def initialize
    @equities = EquityQueries.new
    @company_instrument_query = CompanyInstrumentQuery.new
  end

  def header
      return ["ShareIndex","DateOfPrice", "MarketCap", "PeRatio", "ClosePrice", 
              "FiftyTwoWkGrowth","SixMonthGrowth","FourWkGrowth", "RelativeStrength",
               "Sector","Industry"]
  end

  def generate(date)
    equities = @equities.get_highest_52wkGrowth(date)

    rows = get_rows(equities, date)

    return rows
  end

  def get_rows(equities,date)
    rows = Array.new

    equities.each do |equity|

      equity = populate_indicators(equity,date)
      row = OpenStruct.new

      row.ShareIndex = equity["ShareIndex"]
      row.DateOfPrice = equity["DateOfPrice"]
      row.MarketCap = equity["MarketCap"]
      row.PeRatio = equity["PeRatio"]
      row.ClosePrice = equity["ClosePrice"]
      row.FiftyTwoWkGrowth = equity["FiftyTwoWkGrowth"]
      row.SixMonthGrowth = equity["SixMonthGrowth"]
      row.FourWkGrowth = equity["FourWkGrowth"]
      row.RelativeStrength = equity["RelativeStrength"]
      row.Sector = equity["Sector"]

      rows.push(row) if (row.Sector.to_s != "") 
    end

    sector_best_rows = Array.new

    rows.each do |row|

      sector_best = 
        rows.select{|rs| rs.Sector == row.Sector}
        .max_by{|rm| rm.FiftyTwoWkGrowth.to_f}

      if row.FiftyTwoWkGrowth == sector_best.FiftyTwoWkGrowth
        sector_best_rows.push(row)
      end

    end

    return sector_best_rows

  end


  def populate_indicators(equity, date)
    relative_strength_analyzer = RelativeStrengthAnalyzer.new
    movement_calculator = MovementCalculator.new
    share_index = equity["ShareIndex"]
    baseline = "DBXUS"

    equity["RelativeStrength"] = relative_strength_analyzer.compare_for_day(share_index,baseline, date).round(2)
    equity["FiveYearGrowth"] = movement_calculator.movement_between_weeks(share_index, date, 260)
    equity["ThreeYearGrowth"] = movement_calculator.movement_between_weeks(share_index, date, 156)
    equity["FiftyTwoWkGrowth"] = movement_calculator.movement_between_weeks(share_index, date, 52)
    equity["SixMonthGrowth"] = movement_calculator.movement_between_weeks(share_index, date, 26)
    equity["FourWkGrowth"] = movement_calculator.movement_between_weeks(share_index, date, 4)

    company_instrument = @company_instrument_query.find_one(share_index)

    if !company_instrument.nil?
      equity["Sector"] = company_instrument["Sector"]
      equity["Industry"] = company_instrument["Industry"]
    end

    return equity
  end

end
