module MatchHelper
  def players_for_select
    Player.order(:surname).pluck(:id, :name, :surname).each_with_object({}) do |arr, hash|
      hash[[arr[2], arr[1]].join(' ')] = arr.first.to_i
    end
  end
end