require_relative '../Calculators/relative_strength_analyzer'

describe RelativeStrengthAnalyzer do
  it "Return -1 if price or growth could not be found" do

    relative_strength_analyzer = RelativeStrengthAnalyzer.new

    relative_strength = relative_strength_analyzer.compare_for_day("WHL","DBXUS", Time.utc(2014,12,25))

    expect(relative_strength).to eq(-1)

  end

  it "When given a share and a baseline, return the strength of the share compared to the baseline" do

    relative_strength_analyzer = RelativeStrengthAnalyzer.new

    relative_strength = relative_strength_analyzer.compare_for_day("WHL","DBXUS", Time.utc(2014,10,8))

    expect(relative_strength.round(2)).to eq 0.29

  end

  it "Calculate DBXUS as baseline compared to SHF on 30 Dec 2014" do
    relative_strength_analyzer = RelativeStrengthAnalyzer.new

    relative_strength = relative_strength_analyzer.compare_for_day("SHF","DBXUS", Time.utc(2014,12,30))

    expect(relative_strength.round(2)).to eq(-0.04)
  end
end
