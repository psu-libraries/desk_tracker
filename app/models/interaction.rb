class Interaction < ActiveRecord::Base
  
  def year
    return self.count_date.strftime('%Y')
  end
  
  
  def month
    return self.count_date.strftime('%b')
  end
  
  ##
  # Returns a hash providing data for the patron timecount time series with each branch as a separate time series, 
  # mean patron counts and max patron count for each day are given.
  #
  # @param [Hash] opts the options for creating the charts
  # @option opts [Array[<String>] :branches A list of branches to include in the data 
  # @option opts [Date] :start_date The start date for the time series
  # @option opts [Date] :end_date The end date for the time series
  def self.patron_count_timeseries(opts = {})
    
    # Get the branches that will be itereated over
    branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
  
    opts = {
      'branches'=> branches, 
      'start_date' => Interaction.order('count_date asc').first.count_date,
      'end_date' => DateTime.now
    }.merge(opts).with_indifferent_access
    
    # Query for the average patron counts
    mean_results  = Interaction.where(page: 'Patron Count').
      where("optional_text <> ''").
      where(count_date: (opts['start_date']..opts['end_date'])).
      select('max(id)').
      order('count_date asc').
      group(:count_date).
      group(:branch).
      average('cast(optional_text as float)')
    
    # Query to get the max patron counts
    max_results  = Interaction.where(page: 'Patron Count').
      where("optional_text <> ''").
      where(count_date: (opts['start_date']..opts['end_date'])).
      select('max(id), max(cast(optional_text as float))').
      order('count_date asc').
      group(:count_date).
      group(:branch).
      maximum('cast(optional_text as integer)')
      
    dates = (mean_results .keys.first.first..mean_results .keys.last.first)
    data = {datasets: []}
    
    # The data requires some processing to account for bad data and also to fill in missing dates with zeros.
    # A random color is also supplied since the Highcharts runs out of colors.
    opts['branches'].sort.each do |branch|
      dataset = {unit: 'Patrons', color: "##{SecureRandom.hex(3)}", name: branch, data: [], maxdata: [], type: 'line', maxtype: 'scatter', valueDecimals: 2}
      dates.each do |date| 
        value = (mean_results [[date, branch]].nil? ? 0 : mean_results [[date, branch]]).to_f
        max_value = (max_results [[date, branch]].nil? ? 0 : max_results [[date, branch]]).to_i
        
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
  
  def self.patron_count_by_year(opts = {})
    # Get the branches that will be itereated over
    branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
  
    opts = {
      'branches'=> branches, 
    }.merge(opts).with_indifferent_access
    
    query = Interaction.select('MAX(id)').
      where(page: 'Patron Count').
      where("optional_text <> ''").
      group(:year).
      group(:branch).
      order('branch, year')
      
    mean_results = query.average('CAST(optional_text as integer)')
    max_results = query.maximum('CAST(optional_text as integer)')
    
    year_keys = mean_results.keys.collect { |k| k.first }
      
    data = {years:  (year_keys.min..year_keys.max).to_a, start: year_keys.min, datasets: []}
    
    opts['branches'].sort.each do |branch|
      dataset = {unit: 'Patrons', color: "##{SecureRandom.hex(3)}", name: branch, mean_data: [], max_data: [], type: 'line', valueDecimals: 2}
      data[:years].each do |year|
        dataset[:mean_data] << (mean_results[[year, branch]].nil? ? 0 : mean_results [[year, branch]]).to_f
        dataset[:max_data] << (max_results[[year, branch]].nil? ? 0 : max_results [[year, branch]]).to_i
      end
      data[:datasets] << dataset
    end  
    
    return data
      
  end
  
  def self.mean_daily_use_heatmap(opts = {})
    # Get the branches that will be itereated over
    branches = Interaction.where(page: 'Patron Count').select(:branch).distinct.collect { |b| b.branch }
  
    opts = {
      'branches'=> branches, 
    }.merge(opts).with_indifferent_access
    
    # visits = Analyzable::Visit.where("avatar_name like ?", "%#{opts[:avatar_name]}%").where(
 #        rezzable_id: rezzable_ids, rezzable_type: 'Rezzable::TrafficCop', created_at: (opts[:start_date]..opts[:end_date])
 #        )
 #        heatmap = Array.new(24) { |y| Array.new(7) { |x| [x, y, 0] } }
 #        visits.each { |v| heatmap[v.departed_at.hour][v.departed_at.wday][2] += 1 }
 #        heatmap.flatten(1)
    mean_counts = Interaction.select('MAX(id)').
      where(page: 'Patron Count').
      where("optional_text <> ''").
      where(count_date: (opts['start_date']..opts['end_date'])).
      group(:branch, :day_of_week, :hour_of_day).
      average('CAST(optional_text as integer)')
      
    max_counts = Interaction.select('MAX(id)').
      where(page: 'Patron Count').
      where("optional_text <> ''").
      where(count_date: (opts['start_date']..opts['end_date'])).
      group(:branch, :day_of_week, :hour_of_day).
      maximum('CAST(optional_text as integer)')
      
    data = {datasets: []}
    
    puts mean_counts [['Arts & Humanities', 6, 23]].to_f
      
    opts[:branches].each do |branch|

      dataset = {unit: 'Patrons', color: "##{SecureRandom.hex(3)}", name: branch, mean_data: Array.new(24) { |y| Array.new(7) { |x| [x, y, 0] } }, max_data: Array.new(24) { |y| Array.new(7) { |x| [x, y, 0] } }, valueDecimals: 2}
      
      (0..6).each do |day|
        (0..23).each do |hour|
          dataset[:mean_data][hour][day][2] = mean_counts [[branch, day, hour]].to_f
          dataset[:max_data][hour][day][2] = max_counts [[branch, day, hour]].to_i
        end
      end
      
      data[:datasets] << dataset
    end
    
    return data
    
    
      
  end
  
  def branch_to_key branch
    branch.gsub(/&/, 'and').gsub(/ /, '_').downcase
  end
end
