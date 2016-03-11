defmodule StockAnalyzerTestHelper do
  import MongoHelper

  def create_new_equity(share_index, date_string, close) do

    MongoRepository.insert(%
                           {ShareIndex: share_index,
                            DateOfPrice: string_to_bson_date!(date_string),
                            ClosePrice: close,
                            Latest: true}, "Equity")
  end

  def clear_collection(collection_name) do
    MongoRepository.drop_collection(collection_name)
  end
end
