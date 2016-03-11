require_relative '../Repositories/mongo_repository'

class ClosePriceQuery

  def self.query(params)
    date = params[:date]
    share_index = params[:share_index]

    repo = MongoRepository.new("Equity")

    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    equity = repo.find_by_query({ :$and =>
      [
        {:ShareIndex => share_index},
        {:DateOfPrice => {:$gte => start_date}},
        {:DateOfPrice => {:$lte => end_date}},
        {:Latest => true}
      ]}).first

    return -1 if equity.nil?

    equity["ClosePrice"]
  end

end
