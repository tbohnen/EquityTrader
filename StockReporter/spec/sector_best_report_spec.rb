require_relative '../Reports/sector_best_report'

describe SectorBestReport do

  it "should only return the best in sector for given day" do
    #TODO Figure out why this test is failing, there appears to be one sector that duplicates...

    my_stocks_report = SectorBestReport.new
    rows = my_stocks_report.generate(Time.new(2014,12,1))

    group = rows.group_by{|e| e["Sector"]}

    one_equity_in_group = group.all?{|g| g[1].count == 1}

    expect(one_equity_in_group).to eq(true)
  end

end 
