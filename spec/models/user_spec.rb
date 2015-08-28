require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }
  
  it { should respond_to :role}
  
  it 'should have default value of 1' do
    expect(user.role).to eq 'user'
  end
end
