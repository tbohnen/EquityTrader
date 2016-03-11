defmodule Something do
  use ExUnit.Case

  test "insert a 100 individual records" do
                                           something = [1,2,3,4,5]
    IO.inspect Enum.map(something, (&(&1 * &1))) |> Enum.to_list
  end


end
