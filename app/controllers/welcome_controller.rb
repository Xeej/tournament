class WelcomeController < ApplicationController
  before_action { @section = t('welcome.title') }

  # GET /welcome
  # GET /welcome.json
  def index
  end

end
