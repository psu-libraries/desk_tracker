require 'api_constraints'

Rails.application.routes.draw do


  ActiveAdmin.routes(self)
  
  root to: 'admin/interactions#index'
  
  devise_for :users
  
  post 'interactions/import' => 'interactions#import'
  
  namespace :api, constraints: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get 'interactions/patron_counts_timeseries', to: 'interactions#patron_count_timeseries'
      get 'interactions/patron_counts_by_year', to: 'interactions#patron_count_by_year'
      get 'interactions/patron_counts_by_month', to: 'interactions#patron_count_by_month'
      get 'interactions/daily_use_heatmap', to: 'interactions#daily_use_heatmap'
      get 'interactions/reference_timeseries', to: 'interactions#reference_timeseries'
    end
  end
  
  mount DelayedJobWeb => "/delayed_job"
 
end
