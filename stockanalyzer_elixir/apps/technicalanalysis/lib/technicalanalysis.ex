defmodule TechnicalAnalysis do
  use Timex
  import MongoHelper
  require Logger

  def generate_all_between_days(date, end_date) when date == end_date do
    generate_all_for_day(date)
  end

  def generate_all_between_days(date, end_date) do
    generate_all_for_day(date)
    generate_all_between_days(Date.shift(date, days: 1), end_date )
  end

  def generate_all_for_day(date) do
    equities = ShareIndexesForDateQuery.query(date)
    Logger.debug "Generating Technical Analytics for " <> DateFormat.format!(date, "{YYYY}-{0M}-{0D}") <> " with count " <> Integer.to_string(Enum.count(equities))
    Enum.map equities, fn e -> generate_for_day e, date end
  end

  def generate_for_day(share, date) do
    Logger.debug "generating for " <> share <> " on " <> DateFormat.format!(date, "{YYYY}-{0M}-{0D}")

    daily = MovementCalculator.movement_for(share,date,1)
    two_week = MovementCalculator.movement_for(share,date,14)
    four_week = MovementCalculator.movement_for(share,date,28)
    six_month = MovementCalculator.movement_for(share,date,180)
    one_year = MovementCalculator.movement_for(share,date,365)
    three_year = MovementCalculator.movement_for(share,date,1095)
    five_year = MovementCalculator.movement_for(share,date,1825)

    set_previous_to_non_official(share, date)

    MongoRepository.insert(%
                           {ShareIndex: share,
                            Date: date_to_bson(date),
                            Official: true,
                            DailyMovement: daily,
                            TwoWkGrowth: two_week,
                            FourWkGrowth: four_week,
                            SixMonthGrowth: six_month,
                            OneYearGrowth: one_year,
                            ThreeYearGrowth: three_year,
                            FiveYearGrowth: five_year
                           },
                           "TechnicalIndicator")

  end

  defp set_previous_to_non_official(share, date) do

    date_part = {date.year, date.month, date.day}

    start_time = Date.from({date_part, {0, 0, 0}})
    end_time = Date.from({date_part, {23, 59, 59}})

    MongoRepository.find(
      %{
        '$and':
        [
          %{ShareIndex: share},
          %{Date: %{'$gte': start_time |> date_to_bson }},
          %{Date: %{'$lte': end_time |> date_to_bson }},
          %{Official: true}]

      },"TechnicalIndicator") |>
      Enum.each fn indicator ->
      indicator = %{indicator | Official: false}
      MongoRepository.update(%
                             {_id: indicator."_id"},
                             indicator,
                             "TechnicalIndicator",
                             false,
                             false)
    end



  end
end
