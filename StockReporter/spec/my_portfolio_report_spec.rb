require_relative '../Reports/my_portfolio_report'
require 'ruby-prof'

describe MyPortfolioReport do
  it "should be blank for non-existant user id" do

    report = MyPortfolioReport.new

    user_id = '14da1b7fc75928d3c3683355'
    start_date = "1-Dec-2014"
    end_date = "5-Dec-2014"

    params = {:startdate => start_date, :enddate => end_date, :userId => user_id}

    rows = report.generate(params)

    expect(rows.count).to eq 0
  end

  it "should return my portfolio with average growth per business day" do
    report = MyPortfolioReport.new

    user_id = '54d8f0ee954ab50c440000f4'
    start_date = "1-Dec-2014"
    end_date = "5-Dec-2014"

    params = {:startdate => start_date, :enddate => end_date, :userId => user_id}

    rows = report.generate(params)

    expect(rows.count).to eq 5
    expect(rows[0].date.nil?).to be false
    expect(rows[1].date.nil?).to be false
    expect(rows[2].date.nil?).to be false
    expect(rows[3].date.nil?).to be false
    expect(rows[4].date.nil?).to be false
  end

  it "Should return my portfolio with the rand value of my portfolio per per unit" do
    report = MyPortfolioReport.new

    user_id = '54d8f0ee954ab50c440000f4'
    start_date = "1-Oct-2014"
    end_date = "10-Oct-2014"

    params = {:startdate => start_date, :enddate => end_date, :userId => user_id}

    rows = report.generate(params)

    expect(rows[3].portfolioUnitPrice).to eq (5433)
  end

  it "Should return portfolio unit price for 2014-10-01" do
    report = MyPortfolioReport.new

    user_id = '54d8f0ee954ab50c440000f4'
    start_date = "1-Dec-2014"
    end_date = "1-Dec-2014"

    params = {:startdate => start_date, :enddate => end_date, :userId => user_id}

    rows = report.generate(params)
    expect(rows[0].portfolioUnitPrice).to be > (0)
  end

  it "Should Return Overall Gains for 2015 01 23" do
    report = MyPortfolioReport.new

    user_id = '54d8f0ee954ab50c440000f4'
    start_date = "23-Jan-2015"
    end_date = "26-Jan-2015"

    params = {:startdate => start_date, :enddate => end_date, :userId => user_id}

    rows = report.generate(params)

    expect(rows[0].portfolioOverallValue).to be > (0)
    expect(rows[1].portfolioOverallValue).to be > (0)
  end

end

