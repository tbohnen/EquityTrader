require_relative '../Calculators/movement_calculator'

describe MovementCalculator do
  it "Should return movement over a weekend" do
    movement_calculator = MovementCalculator.new
    difference = movement_calculator.business_day_movement("SHF",Time.new(2014,11,24))
    expect(difference).to eq (0.3)
  end

  it "Should return -0.1 movement for WHL between 19 and 20 oct when movement is negative" do
    movement_calculator = MovementCalculator.new
    difference = movement_calculator.business_day_movement("WHL",Time.new(2014,10,20))
    expect(difference).to eq (-2.07)
  end

  it "Should return 0.1 movement for WHL between 2 Oct and 1 Oct when movement is positive" do
    movement_calculator = MovementCalculator.new
    difference = movement_calculator.business_day_movement("WHL",Time.new(2014,10,02))
    expect(difference).to eq (2.64)
  end


  it "Should return the correct difference between two different days XXX" do
    movement_calculator = MovementCalculator.new
    difference = movement_calculator.movement_between_days("WHL",Time.new(2014,10,31),Time.new(2014,9,25))
    expect(difference).to eq (15.19)
  end

  it "should return -1 if one or both of the days (after converting to business day if applicable) do not exist" do
    movement_calculator = MovementCalculator.new

    # split out or figure out a way to do proper test cases

    difference = movement_calculator.business_day_movement("WHL",Time.new(2000,1,1))
    expect(difference).to eq (-1)

    difference = movement_calculator.movement_between_days("WHL",Time.new(2014,10,31),Time.new(2000,9,25))
    expect(difference).to eq (-1)

    difference = movement_calculator.movement_between_days("WHL",Time.new(2000,10,31),Time.new(2014,9,25))
    expect(difference).to eq (-1)
  end

  it "should return 3 year growth for given share and growth" do
    movement_calculator = MovementCalculator.new
    date = Time.new(2015,01,06)
    share_index = "SHF"

    growth = movement_calculator.movement_between_weeks(share_index, date, 156)

    expect(growth).to be > 0
  end

  it "should return 52 week growth for given share and growth" do
    movement_calculator = MovementCalculator.new
    date = Time.new(2015,01,06)
    share_index = "SHF"

    growth = movement_calculator.movement_between_weeks(share_index, date, 52)

    expect(growth).to be > 0
  end

  it "When one of the prices are not a number it should return -1 and not NaN" do
    movement_calculator = MovementCalculator.new
    date = Time.new(2015,01,07)
    share_index = "FPT"

    difference = movement_calculator.business_day_movement(share_index,date)

    expect(difference).to eq(-1)

  end

end
