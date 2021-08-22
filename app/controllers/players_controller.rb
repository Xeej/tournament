class PlayersController < ApplicationController
  require 'will_paginate/array'
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :payment]
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :encode_photo, only: [:update, :create]
  before_action { @section = t('players.title') }

  # GET /players
  # GET /players.json
  def index
    # if params[:filter].present? && params['filter-data'].present?
    #   if params[:filter] == 'canton'
    #     @players = Player.where(canton: params['filter-data'])
    #   elsif params[:filter] == 'character'
    #     @players = Player.where("? = ANY (main_characters)", params['filter-data'])
    #   end
    # else
      @players = Player.all
    # end

    # handle search parameter
    if params[:search].present?
      begin
        @players = @players.search(params[:search])
        if @players.empty?
          flash.now[:alert] = t('flash.alert.search_players')
        end
      rescue ActiveRecord::StatementInvalid
        @players = Player.all.iLikeSearch(params[:search])
        if @players.empty?
          flash.now[:alert] = t('flash.alert.search_players')
        end
      end
    end
    # handle sort parameter
    sort = params[:sort]
    if sort.present?
      case sort
      when 'win_loss_ratio'
        if params[:order] == "desc"
          @players = @players.sort_by do |p|
            [p.win_loss_ratio, -p.created_at.to_i]
          end.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
        else
          @players = @players.sort_by do |p|
            [p.win_loss_ratio, -p.created_at.to_i]
          end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
        end
      else
        @players = @players.order("players.?".gsub('?', params[:sort])).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      end
    else
      @players = @players.order(created_at: :desc).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    end
    # handle the order parameter
    if params[:order] == "desc" and !@players.is_a?(Array)
      @players = @players.reverse_order
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # GET /players/1/payment
  def payment
    @player = Player.find(params[:id])

    return if params.dig(:date, :month).blank?

    # TODO вынести в сервис
    @payment = true
    days_weeks = []
    month = params['date']['month'].to_i
    week_id = 1
    day = Time.new(Time.now.year, month, 1)
    while day.month == month do
      if day.sunday.month == month
        days_weeks << (day..day.sunday)
      else
        days_weeks << (day..day.end_of_month)
      end
      day = (day.sunday + 1.day).monday
    end
    @all_amount = 0
    @weeks = days_weeks.map.with_index do |days, index|
      count_set_2 = @player.matches.where(start_time: days).where.not(player2_set_2: nil, player1_set_2: nil, player2_set_1: nil, player1_set_1: nil).where(player2_set_3: nil, player1_set_3: nil).count
      count_set_3 = @player.matches.where(start_time: days).where.not(player2_set_2: nil, player1_set_2: nil, player2_set_1: nil, player1_set_1: nil, player2_set_3: nil, player1_set_3: nil).count
      price_set_2 = @player.two_set_amount * count_set_2 rescue @player.two_set_amount.nil? ? 'Сумма за 2 сета не указана' : 'Данных игр не сыграно'
      price_set_3 = @player.three_set_amount * count_set_3 rescue @player.three_set_amount.nil? ? 'Сумма за 3 сета не указана' : 'Данных игр не сыграно'
      @all_amount += price_set_2.to_i + price_set_3.to_i
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
  end

  # # POST /players
  # # POST /players.json
  def create
    @player = Player.new(player_params.merge(photo: @photo))
  
    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: t('flash.notice.player_created') }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /players
  # # DELETE /players.json
  def destroy
    if current_user.super_admin? or current_user.is_admin?
      if @player.destroy
        # render
        redirect_to players_path, notice: t('flash.notice.player_destroyed')
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update

    respond_to do |format|
      if @player.update(player_params.merge(photo: @photo))
        @player.save
        # render
        format.html { redirect_to @player, notice: t('flash.notice.player_updated') }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /players/unregistered
  def unregistered
  end

  private

    def encode_photo
      photo = player_params['photo']&.read
      return @photo = nil unless @player

      @photo = photo.nil? ? @player.photo : Base64&.encode64(photo)&.gsub("\n",'')
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :surname, :patronymic, :comment, :best_rank, :wins,
        :losses, :created_at, :updated_at, :canton, :gender,
        :birth_year, :photo, :three_set_amount, :two_set_amount)
    end

end
