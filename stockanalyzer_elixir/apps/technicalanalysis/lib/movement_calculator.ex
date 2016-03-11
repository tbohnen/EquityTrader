defmodule MovementCalculator do
  use Timex
  require Logger

  def movement_for(share, end_date, days) do

    start_date = Date.shift(end_date, days: -days)

    earliest_price = ClosePriceQuery.query(share, start_date)
    latest_price = ClosePriceQuery.query(share, end_date)

    if (earliest_price == -1 || latest_price == -1 || earliest_price == 0) do
      -1
    else
      ((latest_price / earliest_price) - 1) * 100 |> Float.round 2
    end

  end

  def format_date(date) do
    DateFormat.format!(date, "{YYYY}-{0M}-{0D}")
  end

end
