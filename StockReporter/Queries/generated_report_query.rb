require_relative '../Repositories/mongo_repository'

class GeneratedReportQuery
  def initialize
    @repo = MongoRepository.new("GeneratedReports")
  end

  def query(params)
    report_name = params[:report_name]
    args = params[:args]

    saved_reports = @repo.find_by_query({ 
      :$and =>
      [{:ReportName => report_name}, {:Arguments => args}]})
        .sort(:DateGenerated => -1)

      report = saved_reports.first
      report.to_h if !report.nil?
      Hash.new

  end
end
