require_relative '../Queries/equity_queries'
require_relative '../Calculators/relative_strength_analyzer'
require_relative '../Calculators/movement_calculator'
require_relative '../Calculators/macd_analyzer_old'
require_relative '../Queries/company_instrument_query'
require_relative '../Queries/stock_technical_analysis_query'

class DailyStocksReport

  def initialize(equities)
    @equities = equities
    @company_instrument_query = CompanyInstrumentQuery.new
  end

  def initialize
    @equities = EquityQueries.new
    @company_instrument_query = CompanyInstrumentQuery.new
    @stock_technical_analysis_query = StockTechnicalAnalysisQuery.new
  end

  def header
      return [
        "ShareIndex",
        "ShareName",
        "DateOfPrice",
        "Volume",
        "MarketCap",
        "PeRatio",
        "OpenPrice",
        "ClosePrice",
        "DayMovement", 
        "FiveYearGrowth",
        "ThreeYearGrowth",
        "FiftyTwoWkGrowth",
        "SixMonthGrowth",
        "FourWkGrowth",
        "RelativeStrength",
        "EarningsPerShare",
        "EMA22",
        "MACD",
        "Signal",
        "Histogram",
        "Sector",
        "Industry"
      ]
  end

  def generate(date)
    equities = GetEquitiesByTypeForDate.new.query(:date => date, :type => "Equity").to_a

    rows = get_rows(equities, date)

    return rows
  end

  def get_rows(equities,date)
    rows = Array.new

    equities.each do |equity|

      equity = populate_indicators(equity,date)
      row = OpenStruct.new

      row.ShareIndex = equity["ShareIndex"]
      row.ShareName = equity["ShareName"]
      row.DateOfPrice = equity["DateOfPrice"]
      row.Volume = equity["Volume"]
      row.MarketCap = equity["MarketCap"].to_f
      row.PeRatio = equity["PeRatio"]
      row.OpenPrice = equity["OpenPrice"]
      row.ClosePrice = equity["ClosePrice"].to_f.round(2)
      row.DailyMovement = equity["DailyMovement"]
      row.FiveYearGrowth = equity["FiveYearGrowth"]
      row.ThreeYearGrowth = equity["ThreeYearGrowth"]
      row.FiftyTwoWkGrowth = equity["FiftyTwoWkGrowth"]
      row.SixMonthGrowth = equity["SixMonthGrowth"]
      row.FourWkGrowth = equity["FourWkGrowth"]
      row.EarningsPerShare = equity["Eps"]
      row.EMA22 = equity["Ema22"]
      row.Sector = equity["Sector"]
      row.Industry = equity["Industry"]

      rows.push(row)
    end

    return rows
  end

  def populate_indicators(equity, date)
    share_index = equity["ShareIndex"]

    technical_analysis = @stock_technical_analysis_query.query(share_index, date)

    if !technical_analysis.nil?
        equity["DailyMovement"] = technical_analysis["DailyMovement"]
        equity["FiveYearGrowth"] = technical_analysis["FiveYearGrowth"]
        equity["ThreeYearGrowth"] = technical_analysis["ThreeYearGrowth"]
        equity["FiftyTwoWkGrowth"] = technical_analysis["OneYearGrowth"]
        equity["SixMonthGrowth"] = technical_analysis["SixMonthGrowth"]
        equity["FourWkGrowth"] = technical_analysis["FourWkGrowth"]
    end

    company = @company_instrument_query.find_one(share_index)

    if !company.nil?
      equity["Sector"] = company["Sector"]
      equity["Industry"] = company["Industry"]
      equity["ShareName"] = company["CompanyName"]
    end
    return equity
  end

end
