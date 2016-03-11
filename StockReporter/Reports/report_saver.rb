require_relative '../Repositories/mongo_repository'

class ReportSaver

  def initialize(report)
    @report = report
  end

  def save(*args)
    rows = @report.generate(*args)

    save_rows(rows)
  end

  private

  def save_rows(rows)
    repository = MongoRepository.new(@report.class.name)
    rows.each{|row| repository.insert(row.to_h)}
  end
end
