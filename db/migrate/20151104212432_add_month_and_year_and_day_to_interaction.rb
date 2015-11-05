class AddMonthAndYearAndDayToInteraction < ActiveRecord::Migration
  def change
    add_column :interactions, :day_of_week, :integer
    add_column :interactions, :day_of_month, :integer
    add_column :interactions, :day_of_year, :integer
    add_column :interactions, :hour_of_day, :integer
    add_column :interactions, :year, :integer
    add_column :interactions, :month, :integer
  end
end
