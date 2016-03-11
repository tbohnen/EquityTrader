require_relative '../cached_reports_generator'
require 'rspec'

describe CachedReportsGenerator do

  it "should regenerate all reports" do
    report_generator = CachedReportsGenerator.new
    report_generator.regenerate_all_reports(Time.utc(2015,1,7))
  end

  it "should send notification after generated" do

  end
end
