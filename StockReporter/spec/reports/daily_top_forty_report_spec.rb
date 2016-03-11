require_relative '../../Reports/daily_top_forty_report'
require 'ruby-prof'

describe DailyTopFortyReport do
  it "Needs to have adequate performance" do

    report = DailyTopFortyReport.new
    date = Time.new(2015,05,07)

    result = RubyProf.profile do
      results = report.generate(date)
      puts results
    end

    printer = RubyProf::MultiPrinter.new(result)
    printer.print(:path => ".", :profile => "profile")


  end
end
