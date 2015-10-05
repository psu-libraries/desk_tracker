class ImportCSVJob < Struct.new(:import_id)
  
  def perform()
    import = CSVImport.find self.resource_id
    import.import
  end    

  def enqueue(job)
    job.resource_id   = import_id
    job.resource_class = 'CSVImport'
    job.save!
  end
end