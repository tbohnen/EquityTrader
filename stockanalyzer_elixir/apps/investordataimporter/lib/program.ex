defmodule InvestorDataImporter.Program do

    def main(args) do
      args |> parse_args |> process
    end

    defp process([]) do
      IO.puts "Current commands are:"
      IO.puts "Historical: Imports InvestorData historical file"
      IO.puts "CompanyData: Imports Company Data From A File"
      IO.puts "CompanySectors: Adds the company sectors or imports if company does not exist. Ultimately this should be done through a different mechanism"
      IO.puts "DailyImport: Imports Daily InvestorData price data"
      IO.puts "DailyImportFolder: Imports All Daily InvestorData prices in folder"
    end

    defp process(options) do
       case options[:command] do
         "Historical" -> InvestorDataImporter.import_historical_to_db(options[:path])
         "CompanyData" -> InvestorDataImporter.import_company_names(options[:path])
         "CompanySectors" -> CompanyImport.import_company_types(options[:path])
         "DailyImport" -> InvestorDataImporter.import_daily_file(options[:path])
         "DailyImportFolder" -> InvestorDataImporter.import_all_daily_files_from_folder(options[:path])
       end
    end

    defp parse_args(args) do
      {options, _, _} = OptionParser.parse(args, switches: [command: :string, path: :string])
      IO.puts "running with: "
      IO.inspect options
      options
    end
end
