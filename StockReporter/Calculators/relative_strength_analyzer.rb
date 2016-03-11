require_relative '../Queries/equity_queries'
require_relative 'movement_calculator'

class RelativeStrengthAnalyzer

  def compare_for_day(share_index,baseline_index,date)
    equity_queries = EquityQueries.new
    movement_calculator = MovementCalculator.new

    share = equity_queries.get_share(share_index,date)
    baseline = equity_queries.get_share(baseline_index,date)

    previous_date = business_day_before(date, 26)

    share_six_month_growth = movement_calculator.movement_between_days(share_index, date, previous_date)
    baseline_six_month_growth = movement_calculator.movement_between_days(baseline_index, date, previous_date)

    return -1 if share.nil? || baseline.nil? || share_six_month_growth.to_f == 0.0 || baseline_six_month_growth.to_f == 0.0 

    return share_six_month_growth / baseline_six_month_growth

  end

  private

  def remove_days(time, n_days)
    t2 = time - (n_days * 86400)
    utc_delta = time.utc_offset - t2.utc_offset
    (utc_delta == 0) ? t2 : t2 + utc_delta
    return t2
  end

  def business_day_before(date, days)
    new_date = remove_days(date, (days * 7))
    while new_date.wday == 0 || new_date.wday == 6
      new_date = remove_days(new_date, 1)
    end
    return new_date
  end

end
