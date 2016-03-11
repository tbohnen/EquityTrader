require_relative '../Queries/equity_queries'
require_relative '../Queries/company_instrument_query'
require_relative '../Queries/top_performers_query'

class DailyTopPerformersReport

  def initialize
    @company_instrument_query = CompanyInstrumentQuery.new
  end

  def generate(date)
    bottom_performers = TopPerformersQuery.new.query(:date => date)

    rows = Array.new

    bottom_performers.each do |bottom_performer|

      row = OpenStruct.new

      share_index = bottom_performer["ShareIndex"]

      equity = EquityQueries.new.get_share(share_index, date)

      next if equity["ClosePrice"] < 1000.0

      company = get_company(share_index)

      if !company.nil?
        row.ShareName = company["ShortName"] if !company["ShortName"].nil?
        bottom_performer["ShareName"] = company["CompanyName"] if !company["ShareName"].nil?
      end

      row.ShareIndex = bottom_performer["ShareIndex"]
      row.ClosePrice = equity["ClosePrice"].to_f.round
      row.DailyMovement = bottom_performer["DailyMovement"]

      rows << row
      break if rows.count == 10
    end

    return rows

  end

  def get_company share_index
    @company_instrument_query.find_one(share_index)
  end

  def get_daily_movement(share_index, date)
    query = StockTechnicalAnalysisQuery.new

    result = query.query(share_index, date)
    result[:DailyMovement]
  end

end
