require "rails_helper.rb"

RSpec.describe "Home/New Page" do


  context "visit the root path" do
    before do
      visit root_path
    end

    it "landing page should have new board form, recent boards, link to all boards" do
      #within(first("#form")) do
        expect(page).to have_field 'board[name]'
        expect(page).to have_field 'board[email]'
        expect(page).to have_field 'board[width]'
        expect(page).to have_field 'board[height]'
        expect(page).to have_field 'board[mines]'
        expect(page).to have_button('Generate Board')
      #end

      expect(page).to have_link('View all generated boards')
    end
  end

  context "create board" do
    before do
      visit new_board_path
    end

    it "creates a valid board" do

    end
    
    it "redirects to the show page after creating a board" do
    end

  end

  context "show board" do
    let(:board) { create(:board) }

    before do
      visit board_path(board)
    end

    it "should show the board info" do
    end
  end

  context "boards index" do
  end
end
