require 'csv'
require 'excelinator'

class ExcelReportGenerator

  def initialize(report)
    @report = report
  end

  def save_as(file_name, *args)
    rows = @report.generate(*args)

    csv_content = header_line(rows) + generate_report(rows)
    File.write(file_name + ".csv",csv_content)
    Excelinator.csv_to_xls_file(file_name + ".csv",file_name + ".xls")
    File.delete(file_name + ".csv")
  end

  private

  def header_line(rows)
    header_line = CSV.generate{|csv|
      first_row = rows.first
      headers = first_row.to_h.keys
      csv << headers
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
    row.to_h.each{|key, value|
      line << value
    }
    return line
  end

end
