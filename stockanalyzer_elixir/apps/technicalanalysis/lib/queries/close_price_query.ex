defmodule ClosePriceQuery do
  use Timex

  def query(share, date) do

    start_date = date |> Date.shift(days: -5)

    start_date_part = {start_date.year, start_date.month, start_date.day}
    end_date_part = {date.year, date.month, date.day}

    start_time = Date.from({start_date_part, {0, 0, 0}})
    end_time = Date.from({end_date_part, {23, 59, 59}})

    item = MongoRepository.find(
                                %{
                                    '$and':
                                    [
                                    %{ShareIndex: share},
                                    %{DateOfPrice: %{'$gte': start_time |> date_to_bson }},
                                    %{DateOfPrice: %{'$lte': end_time |> date_to_bson }},
                                    %{Latest: true}]
                                },"Equity")

    |> Enum.sort(&(&1[:DateOfPrice] > &2[:DateOfPrice]))
    |> Enum.at 0

    close = item[:ClosePrice]

    case close do
      nil -> -1
      x when is_number(x) -> close
      x when is_number(x) != True -> Float.parse(close) |> elem(0)
    end

  end

  def date_to_bson(date) do
    ms = Date.to_secs(date, :epoch) * 1000
    %Bson.UTC{ms: ms}
  end

end
