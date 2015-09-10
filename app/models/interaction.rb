class Interaction < ActiveRecord::Base
  
  def self.import(file)
    CSV.foreach(file.path, encoding: 'ISO-8859-1', headers: true) do |row|
      logger.info row.to_s.colorize(:green)
      row_data = row.to_hash
      row_data['count_date'] = row_data['date_time'].to_date
      interaction = Interaction.where(response_id: row_data['response_id'])
      
      begin 
        if interaction.size == 0
          Interaction.create!(row_data)
        else
          interaction.first.update_attributes(row_data)
        end
      rescue
        flash.alert "Failed to create or update response id: #{row_data['response_id']} - #{row}"
      end
    end
  end
  
  def self.branches(opts={})
    Interaction.select(:branch).distinct
  end
  
  def self.mean_count_timeseries(opts = {})
    branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
    results = Interaction.where(page: 'Patron Count').
      where("optional_text <> ''").
      select('max(id)').
      order('count_date asc').
      group(:count_date).
      group(:branch).
      average('cast(optional_text as float)')
      dates = (results.keys.first.first..results.keys.last.first)
      data = {xData: [], datasets: []}
      
      dates.each do |date|
        data[:xData] << date
      end
      
      branches.each do |branch|
        dataset = {name: branch, data: [], type: 'line', valueDecimals: 2}
        dates.each do |date| 
          dataset[:data] << (results[[date, branch]].nil? ? 0 : results[[date, branch]])
        end
        data[:datasets] << dataset
      end
      
      data
  end
  
  def branch_to_key branch
    branch.gsub(/&/, 'and').gsub(/ /, '_').downcase
  end
end
