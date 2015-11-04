class Interaction < ActiveRecord::Base

  def self.branches(opts={})
    Interaction.select(:branch).distinct
  end
  
  def self.mean_count_timeseries(opts = {})
    
    branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
    opts = {'branches'=> branches}.merge(opts)
    logger.info "opts #{opts}".colorize(:red)
    results = Interaction.where(page: 'Patron Count').
      where("optional_text <> ''").
      where(count_date: (opts['start_date']..opts['end_date'])).
      select('max(id)').
      order('count_date asc').
      group(:count_date).
      group(:branch).
      average('cast(optional_text as float)')
      

    max_results = Interaction.where(page: 'Patron Count').
      where("optional_text <> ''").
      where(count_date: (opts['start_date']..opts['end_date'])).
      select('max(id), max(cast(optional_text as float))').
      order('count_date asc').
      group(:count_date).
      group(:branch).
      maximum('cast(optional_text as integer)')
      
    dates = (results.keys.first.first..results.keys.last.first)
    data = {datasets: []}
    
    opts['branches'].each do |branch|
      dataset = {unit: 'Patrons', color: "##{SecureRandom.hex(3)}", name: branch, data: [], maxdata: [], type: 'line', maxtype: 'scatter', valueDecimals: 2}
      dates.each do |date| 
        value = (results[[date, branch]].nil? ? 0 : results[[date, branch]]).to_f
        max_value = (max_results[[date, branch]].nil? ? 0 : max_results[[date, branch]]).to_i
        
        if value > 300
          counts = Interaction.where(page: 'Patron Count', branch: branch, count_date: date).collect { |i| i.optional_text.to_f }.delete_if { |x| x > 300 }
          logger.info "out of bounds value for #{branch} on #{date}: #{counts}".colorize(:red)
          value = counts.inject{|sum,x| sum + x } / counts.size.to_f
        end
        dataset[:data] << value
        dataset[:maxdata] << max_value
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
