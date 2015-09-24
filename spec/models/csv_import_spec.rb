require 'rails_helper'

RSpec.describe CSVImport, type: :model do
  it { should respond_to :file_name }
  it { should respond_to :row_count }
  it { should respond_to :progress }
  it { should respond_to :status }
  it { should respond_to :time_completed }
  
  it { should validate_presence_of :file_name }
  
  describe 'create' do
    let(:file_path) { "spec/fixtures/desk_tracker_short_data.csv" } 
    let(:import) { CSVImport.create(file_name: Rails.root.join(file_path))}
    it 'should add the filesize' do
      expect(import.file_size).to eq File.size(file_path)
    end
  
    it 'should add the row_count' do
      expect(import.row_count).to eq CSV.read(file_path, encoding: 'ISO-8859-1', headers: true).size
    end
  end
end

