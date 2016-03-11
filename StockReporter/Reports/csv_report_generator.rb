require 'csv'
require 'excelinator'

class CsvReportGenerator

  def initialize(report)
    @report = report
  end

  def save_as(file_name, *args)
    rows = @report.generate(*args)
    csv_content = header_line + generate_report(rows)
    File.write(file_name + ".csv",csv_content)
  end

  private


  def header_line
    header_line = CSV.generate{|csv|
      csv << @report.header
    }
    return header_line
  end

  def generate_report(rows) 
    csv_content = CSV.generate{|csv| 
      rows.each{|row| 
        line = add_line(row)
        csv << line
      }
    }
    return csv_content
  end

  def add_line(row)
    line = []
    @report.header.each{|column_name|
      line << row[column_name] 
    }
    return line
  end

end
