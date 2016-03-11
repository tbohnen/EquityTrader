require_relative '../Queries/company_instrument_query'
require 'ostruct'

describe CompanyInstrumentQuery do
  before(:each) do
    @query = CompanyInstrumentQuery.new
  end

  it "returns nil if instrument does not exist" do
    instrument = get_instrument("ASDF")
    expect(instrument).to eq(1)
    
  end

  it "returns correct instrument for TFG and TFGP" do
    instrument_tfg = get_instrument("TFG")
    expect(instrument_tfg["AlphaCode"]).to eq("TFG")
    expect(instrument_tfg["Sector"]).to eq("General Retailers")

    instrument_tfgp = get_instrument("TFGP")
    expect(instrument_tfgp["AlphaCode"]).to eq("TFGP")
    expect(instrument_tfgp["Sector"]).to eq("Preference Shares")
  end

  it "returns instrument for APN" do
    instrument = get_instrument("APN")
    expect(instrument["AlphaCode"]).to eq("APN")
  end
  
  it "returns instrument for EOH" do
    instrument = get_instrument("EOH")
    expect(instrument["AlphaCode"]).to eq("EOH")
  end

  it "returns the instrument for the given alpha (ShareIndex) code" do
    instrument = get_instrument("SHF")
    instrument = OpenStruct.new(instrument)

    expect(instrument.AlphaCode).to eq("SHF")
    expect(instrument.AsAtDateTime).to eq(Time.utc(2014,12,11,22,00,00))
    expect(instrument.Board).to eq("Main Board")
    expect(instrument.Change).to eq(-41)
    expect(instrument.ISIN).to eq("ZAE000016176")
    expect(instrument.Industry).to eq("Consumer Goods")
    expect(instrument.InstrumentType).to eq("Ordinary Share")
    expect(instrument.IssuerMasterId).to eq(2039)
    expect(instrument.LongName).to eq("Steinhoff Int Hldgs Ltd")
    expect(instrument.Market).to eq("Equity Market")
    expect(instrument.MarketCapitalisation).to eq(145639311782.4)
    expect(instrument.PercentageChange).to eq(-0.7067)
    expect(instrument.Price).to eq(57.6)
    expect(instrument.Sector).to eq("Household Goods & Home Construction")
    expect(instrument.ShortName).to eq("STEINHOFF")
    expect(instrument.Status).to eq("CURRENT")
  end

  def get_instrument(share_index)
    return @query.find_one(share_index)
  end
end
