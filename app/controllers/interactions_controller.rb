class InteractionsController < ApplicationController
  def patron_count_timeseries
    Interaction.patron_count_timeseries
  end
end
