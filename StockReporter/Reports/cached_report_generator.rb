require_relative '../Repositories/mongo_repository'
require_relative '../Queries/generated_report_query'
require 'configatron'

class CachedReportGenerator

  def initialize(report)
    @repo = MongoRepository.new("GeneratedReports")
    @report = report
  end

  def remove_cached_report(*args)

    @repo.remove_by_query({ 
      :$and => 
      [{:ReportName => @report.class.name}, {:Arguments => args}]})

  end

  def regenerate(*args)
    puts "regenerate #{args[0].class.name}"
    puts args[0]

    rows = @report.generate(*args)

    if (rows.count > 0) 
      remove_cached_report(*args)
      save_to_db(rows, *args) 
    end

  end

  def generate(*args)
    puts "generate #{args[0].class.name}"
    puts args[0]

    return @report.generate(*args) if configatron.ignore_cache

    report_name = @report.class.name

    saved_report = GeneratedReportQuery.new.query({:report_name => report_name, :args => args})

    return saved_report["Rows"] if (!saved_report.empty? && saved_report["Rows"].count > 0)

    rows = @report.generate(*args)

    save_to_db(rows, *args) if (rows.count > 0)

    return rows
  end

  def header
    @report.header
  end

  private

  def save_to_db(rows, *args)

    rows = convert_openstructs_to_hash(rows)

    report = { "ReportName" => @report.class.name, "Arguments" => args, "Rows" => rows, "DateGenerated" => Time.now }

    @repo.insert(report)
  end

  def convert_openstructs_to_hash(rows)

    hash_rows = Array.new
    rows.each{|r| hash_rows.push(r.marshal_dump)}
    return hash_rows

  end

end

