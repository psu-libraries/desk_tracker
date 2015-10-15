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
  
  def success(job)
    update_status('success')
  end
  
  def error(job, exception)
    update_status('temp_error')
    # Send email notification / alert / alarm
  end
  
  def failure(job)
    update_status('failure')
    # Send email notification / alert / alarm / SMS / call ... whatever
  end

  def perform
    import = CSVImport.find self.resource_id
    import.import
  end

 private

 def update_status(status)
   import = CSVImport.find self.resource_id
   import.status = status
   import.save!
 end
end