defmodule StockAnalyzerMongoTest do
  use ExUnit.Case
  import Enum
  use Timex

  test "insert a 100 individual records" do
    range = 1..100

    results = range |>
      map(fn i -> %{:Something => i} end) |>
      each(fn i -> MongoRepository.insert(i,"TestSingle") end)
  end

  test "Bulk inserting a collection of items at once" do
    range = 1..100000

    range |>
      map(fn i -> %{:Something => i} end) |>
      MongoRepository.insert("TestBulk")

    inserted = MongoRepository.find(%{}, "TestBulk")
    assert Enum.count(inserted) == 100000
  end


  setup do
    on_exit fn ->
      MongoRepository.drop_collection("TestSingle")
      MongoRepository.drop_collection("TestBulk")
    end
  end

end
