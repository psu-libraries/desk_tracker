class ImportCSVJob < Struct.new(:import_id)
    def enqueue(job)
      job.delayed_reference_id   = import_id
      job.delayed_reference_type = 'CSVImport'
      job.save!
    end
  end