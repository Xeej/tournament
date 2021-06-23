class AdministratorsController < ApplicationController
  before_action { @section = 'Администраторы' }

  # GET /administrators
  # GET /administrators.json
  def index
    @admins = User.where(is_admin: true).order(:area_of_responsibility)
  end

end
