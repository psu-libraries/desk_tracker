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
      data = {datasets: []}
      
      branches.each do |branch|
        dataset = {unit: 'Patrons', name: branch, data: [], type: 'line', valueDecimals: 2}
        dates.each do |date| 
          value = (results[[date, branch]].nil? ? 0 : results[[date, branch]]).to_f
          if value > 300
            counts = Interaction.where(page: 'Patron Count', branch: branch, count_date: date).collect { |i| i.optional_text.to_f }.delete_if { |x| x > 300 }
            logger.info "out of bounds value for #{branch} on #{date}: #{counts}".colorize(:red)
            value = counts.inject{|sum,x| sum + x } / counts.size.to_f
          end
          dataset[:data] << value
        end
        dataset[:start_date] = [dates.first.year, dates.first.month, dates.first.day]
        data[:datasets] << dataset
      end
      
      data
  end
  
  def branch_to_key branch
    branch.gsub(/&/, 'and').gsub(/ /, '_').downcase
  end
end
