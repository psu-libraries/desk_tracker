class Api::V1::InteractionsController < ApplicationController


  ##
  # Skip unneeded validations used for web interface.
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def patron_count_timeseries
    render json: Interaction.mean_count_timeseries
  end
  
end