class BoardsController < ApplicationController

  RECENT = 10.freeze

  def index
    @boards = Board.all_recent_first
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
    @board = Board.new
    @boards = Board.recent(RECENT)
  end

  def create
    @board = Board.new(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, notice: "Board created!" }
      else
        @boards = Board.recent(RECENT)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

    def board_params

      params \
        .require(:board) \
        .permit(
          :name,
          :email,
          :width,
          :height,
          :mines
        )
    end

end
