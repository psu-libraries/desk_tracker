require 'rails_helper'

RSpec.describe CSVImport, type: :model do
  it { should respond_to :file_size }
  it { should respond_to :row_count }
  it { should respond_to :file_name }
  it { should respond_to :progress }
  it { should respond_to :import }
  it { should respond_to :stage }
  
  it { should validate_presence_of :file_name}
  
  let(:import) { build :csv_import }
  let(:filename) { 'spec/fixtures/desk_tracker_short_data.csv'} 
  
  describe 'initialization' do
  
    it 'should have default progress of 0' do
      expect(import.progress).to eq 0
    end
  
    it 'should cmopute the file size' do
      import.save
      expect(import.file_size).to eq File.size(filename)
    end
    
    it 'should compute the number of rows' do
      import.save
      expect(import.row_count).to eq CSV.read(filename, encoding: 'ISO-8859-1', headers: true).size
    end
    
    it 'should have default stage of \'initialized\'' do
      expect(import.stage).to eq 'initialized'
    end
  
  end
  
  describe '#import' do
    before(:each) { import.save }
    
    it 'should add the rows to the database' do
      expect{ import.import }.to change(Interaction, :count).by import.row_count
    end
    
    describe 'progress tracking during import' do
    
      it 'should change the stage to \'complete\'' do
        import.import
        import.reload
        expect(import.stage).to eq 'complete'
      end
    end
  end
  
end
#
# create_table "csv_imports", force: :cascade do |t|
#   t.integer  "file_size"
#   t.integer  "row_count"
#   t.string   "file_name",              null: false
#   t.integer  "progress",   default: 0
#   t.datetime "created_at",             null: false
#   t.datetime "updated_at",             null: false
# end
