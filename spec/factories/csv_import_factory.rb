FactoryGirl.define do
  factory :csv_import, class: 'CSVImport' do
    file_name "spec/fixtures/desk_tracker_short_data.csv"
  end

end
