class Board < ApplicationRecord

  DEFAULT_WIDTH = 10.freeze
  DEFAULT_HEIGHT = 10.freeze
  DEFAULT_DENSITY = 5.freeze  # 1/5

  attribute :width, :integer, default: DEFAULT_WIDTH
  attribute :height, :integer, default: DEFAULT_HEIGHT
  attribute :mines, :integer, default: ((DEFAULT_WIDTH * DEFAULT_HEIGHT) / DEFAULT_DENSITY).to_int

  scope :recent, -> (num) { order(:created_at).reverse.first(num) }

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }   # There's a gem for this...
  validates_with BoardValidator   # validators/board_validator
 
  def render_grid()
   render = \
     "💣◻◻💣◻💣◻◻💣◻" + "\n" +
     "💣◻💣◻💣◻💣◻◻◻" + "\n" +
     "💣◻◻💣◻◻💣💣◻◻" + "\n" +
     "💣◻💣◻◻💣◻◻💣◻" + "\n"
  end
end
