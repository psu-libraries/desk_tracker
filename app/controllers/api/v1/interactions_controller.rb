class Api::V1::InteractionsController < ApplicationController
  
  before_action :process_date_params, only: [:patron_count_timeseries]
  
  ##
  # Skip unneeded validations used for web interface.
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def patron_count_timeseries
    render json: Interaction.patron_count_timeseries(params)
  end
  
  def patron_count_by_year
    render json: Interaction.patron_count_by_year(params)
  end
  
  private

  ##
  # Processes the query params to reduce the chance of bad data being supplied.
  # 
  # @todo Consider adding warning messages to alert the user the query has not behaved as normal.  
  def process_date_params
    
    # Checks start and end dates. Likewise if there is an error the default
    # is to send the entire timeseries
    begin
      params[:start_date] = DateTime.parse(params[:start_date]) unless params[:start_date].nil?
      params[:end_date] = DateTime.parse(params[:end_date]) unless params[:end_date].nil?
    rescue
      params[:start_date] = Interaction.order('count_date asc').first.count_date
      params[:end_date] = DateTime.now
    end
  end
  
end