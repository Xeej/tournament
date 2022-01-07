class MatchesController < ApplicationController
  require 'will_paginate/array'
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  before_action { @section = t('matches.title') }

  # GET /matches
  # GET /matches.json
  def index
    # if params[:filter].present? && params['filter-data'].present?
    #   byebug
    #   if params[:filter] == 'canton'
    #     @matches = Player.where(canton: params['filter-data'])
    #   elsif params[:filter] == 'character'
    #     @matches = Player.where("? = ANY (main_characters)", params['filter-data'])
    #   end
    # else
      @matches = Match.all
    # end

    # handle search parameter
    if params[:search].present?
      begin
        @matches = @matches.search(params[:search])
        if @matches.empty?
          flash.now[:alert] = t('flash.alert.search_matches')
        end
      rescue ActiveRecord::StatementInvalid
        # Двойной joins не работает TODO
        @matches = Match.where(id: Match.all.iLikeSearch(params[:search]).pluck(:id))
        if @matches.empty?
          flash.now[:alert] = t('flash.alert.search_matches')
        end
      end
    end
    # handle sort parameter
    sort = params[:sort]
    if sort.present?
      case sort
      when 'player1'
        @matches = @matches.joins('join players on matches.player_id_1 = players.id').order("players.surname")
      when 'player2'
        @matches = @matches.joins('join players on matches.player_id_2 = players.id').order("players.surname")
      when 'winner'
        @matches = @matches.joins('join players on matches.winner_id=players.id').order("players.surname").order("players.surname")
      else
        @matches = @matches.order("matches.?".gsub('?', params[:sort]))
      end
    else
      @matches = @matches.order(created_at: :desc)
    end
    @matches = @matches.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    # handle the order parameter
    if params[:order] == "desc" and !@matches.is_a?(Array)
      @matches = @matches.reverse_order
    end
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    set_match
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # # POST /matches
  # # POST /matches.json
  def create
    @match = Match.new(match_params)
  
    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: t('flash.notice.match_created') }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    respond_to do |format|
      if @match.update(match_params)
        # render
        format.html { redirect_to @match, notice: t('flash.notice.match_updated') }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.super_admin? or current_user.is_admin?
      if @match.destroy
        # render
        redirect_to matches_path, notice: t('flash.notice.match_destroyed')
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def payment
    return if params.dig(:date, :month).blank?

    @payment = true
    players = Player.all.map do |player|
      PlayerPayment.new(player, params['date']['month'].to_i, params['date']['year'].to_i).call.merge(full_name: player.full_name)
    end
    @month_payment = {
      all_amount: players.sum{ |player| player[:all_amount] },
      players: players
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:player_id_1, :player_id_2, :player1_set_1, :player1_set_2, :player1_set_3, :player2_set_1, 
        :player2_set_2, :player2_set_3, :start_time, :winner, :created_at, :updated_at)
    end

end
