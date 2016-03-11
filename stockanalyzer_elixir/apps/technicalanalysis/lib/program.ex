defmodule Technicalanalysis.Program do
  use Timex

  def main(args) do
    args |> parse_args |> process
  end

  defp process([]) do
    IO.puts "Current commands are:"
    IO.puts "CurrentDay: Technical Analysis For Day"
    IO.puts "Date: TechnicalAnalysis for specified Date: --date 20151231"
    IO.puts "BetweenDays: TechnicalAnalysis between start and end date: --startdate 20150101 --enddate 20151231"
  end

  defp process(options) do
    case options[:command] do
      "CurrentDay" -> TechnicalAnalysis.generate_all_for_day(Date.now)
      "Date" ->
        {:ok, date} = DateFormat.parse(options[:date],"{YYYY}{0M}{0D}")
        TechnicalAnalysis.generate_all_for_day(date)
      "BetweenDays" ->
        {:ok, start_date} = DateFormat.parse(options[:startdate],"{YYYY}{0M}{0D}")
        {:ok, end_date} = DateFormat.parse(options[:enddate],"{YYYY}{0M}{0D}")
        TechnicalAnalysis.generate_all_between_days(start_date, end_date)
    end
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [command: :string, date: :string, startdate: :string, enddate: :string])
    IO.puts "running with: "
    IO.inspect options
    options
  end
end
