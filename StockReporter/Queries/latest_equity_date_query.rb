class LatestEquityDateQuery

  # Maybe consider adding a record of request in the db instead...
  def query()
    equities = MongoRepository.new("Equity")

    latest_date =
      equities
      .find_by_query({"Latest" => true})
      .sort({DateOfPrice:-1})
      .limit(1)
      .first["DateOfPrice"]

    return latest_date
  end

end

