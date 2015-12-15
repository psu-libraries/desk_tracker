class CSVImport < ActiveRecord::Base

  
  validates_presence_of :file_name
  
  def import
    
    self.stage = 'processing'
    self.save
    
    rows = 0
    
    CSV.foreach(self.file_name, encoding: 'ISO-8859-1', headers: true) do |row|
      logger.info row.to_s.colorize(:green)
      row_data = row.to_hash
      
      parsed_date = Chronic.parse(row_data['date_time'])
      row_data['count_date'] = parsed_date
      row_data['month'] = parsed_date.month
      row_data['year'] = parsed_date.year
      row_data['day_of_week'] = parsed_date.wday
      row_data['day_of_month'] = parsed_date.mday
      row_data['day_of_year'] = parsed_date.yday
      row_data['hour_of_day'] = parsed_date.hour
      row_data['data_quality'] = data_quality(row_data)
      interaction = Interaction.where(response_id: row_data['response_id'])
      begin 
        if interaction.size == 0
          Interaction.create!(row_data)
        else
          interaction.first.update_attributes(row_data)
        end
      rescue
        logger.info "Failed to create or update response id: #{row_data['response_id']} - #{row}"
      end
      
      rows += 1

      if rows % 10 == 0
        self.progress = rows
        self.save
      end
    end
    
    self.stage = 'complete'
    self.save
  end
  
  private
  
  def data_quality row_data
    begin
      if row_data['page'] == 'Patron Count'
        return 0 if row_data['optional_text'].nil? || row_data['optional_text'].empty?
        return 0 unless is_numeric? row_data['optional_text']
        return 0 if Integer(row_data['optional_text']) > 300
      end
    rescue
      return 0
    end
    return 2
  end
  
  def is_numeric? input
    true if Float(input) rescue false
  end
  
end
