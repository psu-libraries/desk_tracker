class Api::V1::InteractionsController < ApplicationController
  
  before_action :process_query_params
  
  ##
  # Skip unneeded validations used for web interface.
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def patron_count_timeseries
    logger.info "params #{params}".colorize(:green)
    render json: Interaction.mean_count_timeseries(params)
  end
  

  def process_query_params
    begin
      params[:start_date] = params[:start_date].nil? ? Interaction.order('count_date asc').first.count_date : DateTime.parse(params[:start_date])
      params[:end_date] = params[:end_date].nil? ? DateTime.now : DateTime.parse(params[:end_date])
    rescue
      params[:start_date] = Interaction.order('count_date asc').first.count_date
      params[:end_date] = DateTime.now
    end
  end
  
end