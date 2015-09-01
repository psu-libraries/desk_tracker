class Interaction < ActiveRecord::Base
  
  def self.import(file)
    CSV.foreach(file.path, encoding: 'ISO-8859-1', headers: true) do |row|
      logger.info row.to_s.colorize(:green)
      row_data = row.to_hash
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
end
