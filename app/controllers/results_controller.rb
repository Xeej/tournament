class ResultsController < ApplicationController
  require 'will_paginate/array'
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :payment]
  before_action { @section = t('results.title') }

  # GET /players
  # GET /players.json
  def index
      @players = Player.all

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
      when 'position'
        @players = @players.sort_by(&:position)
      else
        @players = @players.order('players.%{sort}' % { sort: sort })
      end
    else
      @players = @players.sort_by(&:position)
    end

    # handle the order parameter
    if params[:order] == "desc"
      if @players.is_a?(Array)
        @players = @players.reverse
      else
        @players = @players.reverse_order
      end
    end
    @players = @players.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :surname, :patronymic, :comment, :best_rank, :wins,
        :losses, :created_at, :updated_at, :canton, :gender,
        :birth_year, :photo, :three_set_amount, :two_set_amount)
    end

end
