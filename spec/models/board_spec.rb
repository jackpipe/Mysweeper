require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create(:board) }

  context "Validations" do
    [:name, :email, :width, :height, :mines].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end
end
