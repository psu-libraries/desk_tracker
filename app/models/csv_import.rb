class CSVImport < ActiveRecord::Base
  
  validates_presence_of :file_name
  
  def import
    
    self.stage = 'processing'
    self.save
    
    rows = 0
    
    CSV.foreach(self.file_name, encoding: 'ISO-8859-1', headers: true) do |row|
      logger.info row.to_s.colorize(:green)
      row_data = row.to_hash
      
      if valid_row? row_data
        row_data['count_date'] = Chronic.parse(row_data['date_time'])
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
  
  def valid_row? row_data
    begin
      if row_data['page'] == 'Patron Count'
        return false if row_data['optional_text'].nil? || row_data['optional_text'].empty?
        return false unless is_numeric? row_data['optional_text']
        return false if Integer(row_data['optional_text']) > 300
      end
    rescue
      return false
    end
    true
  end
  
  def is_numeric? input
    true if Float(input) rescue false
  end
  
  
end
