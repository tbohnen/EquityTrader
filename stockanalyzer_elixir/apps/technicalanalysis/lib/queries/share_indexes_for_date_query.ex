defmodule ShareIndexesForDateQuery do
  use Timex

  def query(start_date) do

    date_part = {start_date.year, start_date.month, start_date.day}
    start_time = Date.from({date_part, {0, 0, 0}})
    end_time = Date.from({date_part, {23, 59, 59}})

    MongoRepository.find(
      %{
        '$and':
        [
          %{Latest: true},
          %{DateOfPrice: %{'$gte': start_time |> date_to_bson }},
          %{DateOfPrice: %{'$lte': end_time |> date_to_bson }}
        ]},"Equity") |>
      Enum.map fn e -> e[:ShareIndex] end
  end

  def date_to_bson(date) do
    ms = Date.to_secs(date, :epoch) * 1000
    %Bson.UTC{ms: ms}
  end

end
