module BoardsHelper

  BOARD_NAMES = [
    "Board Silly",
    "Board Stiff",
    "All A-board",
    "Star Board",
    "Board Ape",
    "Above Board",
    "Board Panda",
    "Board and loanly",
    "Mine yourself!",
    "All Mine",
    "Mine over matter",
    "Your place or Mine?",
    "Mine de rien",
    "It's da bomb!",
    "Clean sweep",
    "No sweep till Brooklyn",
    "No sweep 'til Hammersmith"
  ].freeze

  def dimensions(board)
    "#{board.width}x#{board.height}"
  end

  def ago(board)
    time_ago_in_words(board.created_at) + " ago"
  end

  # what a card
  def p_please_bob
    BOARD_NAMES.sample
  end
end

