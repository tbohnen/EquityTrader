defmodule AddCompanyTypesTests do
  use ExUnit.Case

  test "when importing a company with it's type then it's applied" do
    InvestorDataImporter.import_company_names('test/data/InvestorDataCompanyNames.TXT')
    CompanyImport.import_company_types('test/data/CompanySectors.txt')

    abil = MongoRepository.find(%{ShortName: "ABIL"}, "Company") |> Enum.at(0)

    assert abil[:Type] == "Equity"
  end

end

