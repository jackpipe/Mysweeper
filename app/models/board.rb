class Board < ApplicationRecord

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

  DEFAULT_WIDTH = 10.freeze
  DEFAULT_HEIGHT = 10.freeze
  DEFAULT_DENSITY = 5.freeze  # 1/5

  attribute :width, :integer, default: DEFAULT_WIDTH
  attribute :height, :integer, default: DEFAULT_HEIGHT
  attribute :mines, :integer, default: ((DEFAULT_WIDTH * DEFAULT_HEIGHT) / DEFAULT_DENSITY).to_int

  # attribute defaults are better, but this is more flexible
  # delete later if not needed
  # - we don't actually need defaults at all for the task
  #after_initialize :set_defaults
  #def set_defaults
  #  self.width ||= DEFAULT_WIDTH
  #  self.height ||= DEFAULT_HEIGHT
  #  self.mines ||= (self.width * self.height * DEFAULT_DENSITY).to_int
  #end

  scope :recent, -> (num) { order(:created_at).reverse.first(num) }

  validates :name, presence: true

  # There's a gem for that, but this will do for now:
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 

  # board validator, just presence for now
  validates :width, :height, :mines, presence: true
 

  # what a card
  def p_please_bob
    BOARD_NAMES.sample
  end

end
