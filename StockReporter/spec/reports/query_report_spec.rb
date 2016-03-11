require_relative '../../Reports/query_report'

describe QueryReport do

  it "Should execute a given query and return the results in the report" do

    report = QueryReport.new()

    result = report.generate({"query" => "TestQuery", :key => "test"})

    expect(result).to eq ["test"]

  end

end

class TestQuery

  def query(params)
    return [params[:key]]
  end
end
