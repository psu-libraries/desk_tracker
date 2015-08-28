FactoryGirl.define do
  factory :interaction do
    response_id { rand(1000..1000000) }
  end

end
