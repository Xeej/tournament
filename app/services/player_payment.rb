class PlayerPayment
  attr_reader :days_weeks, :month, :player

  def initialize(player, month)
    @player = player
    @month = month
    @days_weeks = []
  end

  def call
    define_days_weeks
    weeks = days_weeks.map.with_index do |days, index|
      count_set_2 = count_set_2(days)
      count_set_3 = count_set_3(days)
      price_set_2 = player.two_set_amount * count_set_2 rescue 'Сумма за 2 сета не указана'
      price_set_3 = player.three_set_amount * count_set_3 rescue 'Сумма за 3 сета не указана'
      {
        week_id: index + 1,
        week_days: "#{days.first.day}..#{days.last.day}",
        count_set_2: count_set_2,
        count_set_3: count_set_3,
        price_set_2: price_set_2,
        price_set_3: price_set_3,
        price_sets: price_set_2.to_i + price_set_3.to_i
      }
    end
    {
      all_amount: weeks.sum {|week| week[:price_sets] },
      all_count_set_2: weeks.sum {|week| week[:count_set_2] },
      all_count_set_3: weeks.sum {|week| week[:count_set_3] },
      all_price_set_2: weeks.first[:price_set_2].is_a?(Integer) ? weeks.sum {|week| week[:price_set_2]} : 'Сумма за 2 сета не указана',
      all_price_set_3: weeks.first[:price_set_3].is_a?(Integer) ? weeks.sum {|week| week[:price_set_3]} : 'Сумма за 3 сета не указана',
      weeks: weeks
    }
  end

  private

  def define_days_weeks
    day = Time.new(Time.now.year, month, 1)
    while day.month == month do
      if day.sunday.month == month
        days_weeks << (day..day.sunday)
      else
        days_weeks << (day..day.end_of_month)
      end
      day = (day.sunday + 1.day).monday
    end
  end

  def count_set_2(days)
    player.matches.where(start_time: days).where.not(player2_set_2: nil, player1_set_2: nil, player2_set_1: nil, player1_set_1: nil)
                  .where(player2_set_3: nil, player1_set_3: nil).count
  end

  def count_set_3 (days)
    player.matches.where(start_time: days).where.not(player2_set_2: nil, player1_set_2: nil, player2_set_1: nil, player1_set_1: nil, player2_set_3: nil, player1_set_3: nil).count
  end
end