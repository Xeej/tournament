class Player < ApplicationRecord
  # belongs_to :user, dependent: :destroy
  # has_many :alternative_gamer_tags, dependent: :destroy
  # has_many :registrations, dependent: :destroy
  # has_many :results, dependent: :destroy
  # has_many :tournaments, through: :registrations
  validates :surname, presence: true, on: :create
  validates :name, presence: true, on: :create
  validates :gender, presence: true, on: :create

  before_validation :strip_whitespace
  before_validation :default_win_loses
  before_destroy :destroy_matches

  # scope :from_2019, -> { where('created_at >= ? AND created_at < ?', Time.local(2019,1,1), Time.local(2020,1,1)) }
  # scope :from_2020, -> { where('created_at >= ? AND created_at < ?', Time.local(2020,1,1), Time.local(2021,1,1)) }
  # scope :from_2021, -> { where('created_at >= ? AND created_at < ?', Time.local(2021,1,1), Time.local(2022,1,1)) }

  MAX_PLAYERS_PER_PAGE = 10
  MAX_PLAYER_VIDEOS_PER_PAGE = 5

  def full_name
    [surname, name, patronymic].reject(&:blank?).map(&:strip).join(' ')
  end

  def destroy_matches
    matches.destroy_all
  end

  def self.search(search)
    if search
      sanitizedSearch = ActiveRecord::Base.sanitize_sql_like(search)
      where("name ~* '.*" + ApplicationController.helpers.unaccent(sanitizedSearch) + ".*'").or(where(  # ~* is the case-insensitive regexp operator
        "surname ~* '.*" + ApplicationController.helpers.unaccent(sanitizedSearch) + ".*'"
      ))
    else
      :all
    end
  end

  def default_win_loses
    self.wins ||= 0
    self.losses ||= 0
  end

  def self.iLikeSearch(search)
    if search
      sanitizedSearch = ActiveRecord::Base.sanitize_sql_like(search)
      where("name ILIKE ? or surname ILIKE ?", "%#{sanitizedSearch}%", "%#{sanitizedSearch}%")
    else
      :all
    end
  end

  def win_loss_ratio
    if self.wins == 0 and self.losses == 0
      return 0
    else
      return (self.wins.to_f/(self.wins+self.losses)*100).round(2)
    end
  end

  def seed_points
    seed_points = (self.participations == 0 ? 0 : self.points.to_f/self.participations)
    seed_points += self.win_loss_ratio
    seed_points += self.participations
    seed_points += self.self_assessment.to_f/5
    seed_points += self.tournament_experience.to_f/10
    return seed_points
  end

  def results_sum(city_or_major)
    points = 0
    participations = 0
    wins = 0
    losses = 0
    self.results.each do |r|
      if city_or_major.capitalize == r.city or (r.major_name.present? and r.major_name.downcase.include?(city_or_major.downcase))
        points += r.points
        participations += 1
        wins += r.wins
        losses += r.losses
      end
    end
    if wins == 0 and losses == 0
      return [points, -participations, 0]
    else
      return [points, -participations, (wins.to_f/(wins+losses)*100).round(2)]
    end
  end

  def matches
    Match.where(player_id_2: id).or(Match.where(player_id_1: id))
  end

  def strip_whitespace
    # self.gamer_tag.try(:strip!)
  end
end
