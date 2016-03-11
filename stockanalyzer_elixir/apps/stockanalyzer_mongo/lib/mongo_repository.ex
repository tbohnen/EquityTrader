defmodule MongoRepository do
  require Logger
    @db_name Application.get_env(:db, :dbname)

    def drop_collection(collection_name) do
        get_connection |>
        Mongo.db(@db_name) |>
        Mongo.Db.collection(collection_name) |>
        Mongo.Collection.drop
    end

    def update(query,values, collection_name, upsert, multi) do
      get_connection |>
        Mongo.db(@db_name) |>
        Mongo.Db.collection(collection_name) |>
        Mongo.Collection.update(query, values, upsert, multi)
    end

    def find(query, collection_name) do
      cursor = get_connection
      |> Mongo.db(@db_name)
      |> Mongo.Db.collection(collection_name)
      |> Mongo.Collection.find(query)
      |> Map.put(:batchSize, 100)
    end

    def insert(items, collection_name) when is_list(items) do
      collection = get_connection |>
        Mongo.db(@db_name) |>
        Mongo.Db.collection(collection_name)

      Mongo.Collection.insert(items, collection)
    end

    def insert(item, collection_name) do
      collection = get_connection |>
        Mongo.db(@db_name) |>
        Mongo.Db.collection(collection_name)

        Mongo.Collection.insert_one(item, collection)
    end

    @doc "needs to be checked more thoroughly"
    def get_connection do

      if (is_nil(Process.whereis(__MODULE__))) do
        {:ok, pid} = Agent.start_link(fn -> Mongo.connect!(%{timeout: 120000}) end, name: __MODULE__)
        Logger.debug "Opened connection to " <> @db_name
      end

      Agent.get(__MODULE__, fn mongo -> mongo end)
    end
end
