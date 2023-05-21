require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:subject) { build(:board) }

  context "Validations" do
    [:name, :email].each do |attr|
      it { should validate_presence_of(attr) }
      it "should validate the email format"
    end
  end

  context "Grid" do
    it "creates a grid" do
      g = subject.create_grid
      expect(g.count).to eq(subject.width * subject.height)
    end

    it "creates a single mine" do
      subject.mines = 1
      g = subject.create_grid
      expect(g.count(true)).to eq(1)
    end

    it "creates full board of mines" do
      tiles = subject.width * subject.height
      subject.mines = tiles - 1
      g = subject.create_grid
      expect(g.count(true)).to eq(tiles-1)
    end

    it "creates mines max collision" do
      tiles = subject.width * subject.height
      subject.mines = tiles / 2
      g = subject.create_grid
      expect(g.count(true)).to eq(tiles/2)
    end

    it "creates a big grid" do
      subject = Board.new(width: 1_000, height: 1_000, mines: 500_000)
      g = subject.create_grid
      expect(g.count(true)).to eq(500_000)
      expect(g.count).to eq(1_000_000)
    end
  end
end

