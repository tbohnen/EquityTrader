require_relative '../Repositories/mongo_repository'
class TestData

  def self.create_demo_user
    repo = MongoRepository.new("Users")
    repo.remove_by_query({"Email"=> "TestUser1234567@gmail.com"})
    repo.insert({"Email" => "TestUser1234567@gmail.com"})
    repo.find_by_query({"Email"=> "TestUser1234567@gmail.com"}).first
  end

  def self.create_demo_my_equity(share_index, date, no_of_shares, user_id, purchase_price)
    repo = MongoRepository.new("MyEquities")
    test_my_equity = {"ShareIndex" => share_index, "TransactionType" => "Buy", "DateOfPurchase" => date, "NoOfShares" => no_of_shares, "UserId" => user_id, "PurchasePrice" => purchase_price}

    repo.remove_by_query({"ShareIndex" => share_index, "DateOfPurchase" => date})
    repo.insert(test_my_equity)
    repo.find_by_query({"ShareIndex" => share_index})
  end

  def self.create_demo_company(share_index, short_name, type)
    repo = MongoRepository.new("Company")
    test_company = {"ShareIndex" => share_index, "ShortName" => short_name, :Type => type}

    repo.remove_by_query({"ShareIndex" => share_index})
    repo.insert(test_company)
    repo.find_by_query({"ShareIndex" => share_index})
  end

  def self.create_demo_equity(share_index, date, close_price)
    repo = MongoRepository.new("Equity")
    test_equity = {"ShareIndex" => share_index, "DateOfPrice" => date, "ClosePrice" => close_price, "Latest" => true}

    repo.remove_by_query({"ShareIndex" => share_index,"DateOfPrice" => date})
    repo.insert(test_equity)
    repo.find_by_query({"ShareIndex" => share_index})
  end

  def self.create_technical_data params

    repo = MongoRepository.new("TechnicalIndicator")
    repo.remove_by_query(params)
    repo.insert(params)
    repo.find_by_query(params)

  end
end
