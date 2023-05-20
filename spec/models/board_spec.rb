require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create(:board) }

  context "Validations" do
    [:name, :email, :width, :height, :mines].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  context "Grid", focus: true do
    it "creates a grid" do
      #g = create_grid
      #b place_mines( g, mines)
      #b.compact.count = mines
    end
  end
end

