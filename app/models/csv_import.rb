class CSVImport < ActiveRecord::Base
  # after_validation :get_filesize
 #  after_validation :get_row_count
  
  validates_presence_of :file_name
  
  def import
    
    self.stage = 'processing'
    self.save
    
    rows = 0
    
    CSV.foreach(self.file_name, encoding: 'ISO-8859-1', headers: true) do |row|
      logger.info row.to_s.colorize(:green)
      row_data = row.to_hash
      row_data['count_date'] = Chronic.parse(row_data['date_time'])
      row_data['optional_text'] = 0 unless 
      interaction = Interaction.where(response_id: row_data['response_id'])
      
      if(row_data['page'] == 'Patron Count' and is_number?(row_data['optional_text']))
      
        
      end
      
      rows += 1
      
      # if rows % 10 == 0
#         self.progress = ((rows/self.row_count.to_f)*100).round
#         self.save
#       end
    end
    
    self.stage = 'complete'
    self.save
    self.progress = 100
    self.save
  end
  
  private
  
  def get_filesize
    self.file_size = File.size(self.file_name) if self.file_name
  end
  
  
  def get_row_count
    self.row_count = CSV.read(self.file_name, encoding: 'ISO-8859-1', headers: true).size if self.file_name
  end
  
  def is_number? string
    return true if Float(string) rescue false
  end
end
