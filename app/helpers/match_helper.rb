module MatchHelper
  def players_for_select
    Player.pluck(:id, :name, :surname).each_with_object({}) do |arr, hash|
      hash[[arr[1], arr[2]].join(' ')] = arr.first.to_i
    end
  end
end