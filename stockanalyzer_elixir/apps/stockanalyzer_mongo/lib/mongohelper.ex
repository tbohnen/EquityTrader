defmodule MongoHelper do
  use Timex

  def string_to_bson_date!(date) do
    {:ok, date} = string_to_bson_date(date)
    date
  end

  def string_to_bson_date(date) do
      case DateFormat.parse(date, "{YYYY}{0M}{0D}") do
        {:ok, date} -> {:ok, date |> date_to_bson }
        {:error, message} -> {:error, message}
      end
  end

  def date_to_bson(date) do
    ms = Date.to_secs(date, :epoch) * 1000
    %Bson.UTC{ms: ms}
  end

  def mongo_and_query(query, collection_name) do
    MongoRepository.find(%{'$and': query},collection_name)
  end

  def date_of_price_query(date) do
    start_time = Date.from({date, {0, 0, 0}})
    end_time = Date.from({date, {23, 59, 59}})

    {%{DateOfPrice: %{'$gte': start_time |> date_to_bson }},
     %{DateOfPrice: %{'$lte': end_time |> date_to_bson }}}
  end

  def bson_date_to_datepart(date) do
    {{y,mo,d}, {_,_,_}} = :calendar.now_to_universal_time(Bson.UTC.to_now(date))
    {y, mo, d}
  end

  def bson_date_to_string(date) do
     {{y,mo,d}, {h,mi,s}} = :calendar.now_to_universal_time(Bson.UTC.to_now(date))
     "#{y}-#{mo}-#{d}T#{h}:#{mi}:#{s}"
  end

end
