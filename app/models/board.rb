class Board < ApplicationRecord

  DEFAULT_WIDTH = 10.freeze
  DEFAULT_HEIGHT = 10.freeze
  DEFAULT_DENSITY = 5.freeze  # 1/5

  attribute :width, :integer, default: DEFAULT_WIDTH
  attribute :height, :integer, default: DEFAULT_HEIGHT
  attribute :mines, :integer, default: ((DEFAULT_WIDTH * DEFAULT_HEIGHT) / DEFAULT_DENSITY).to_int

  before_create :create_grid

  scope :recent, -> (num) { order(:created_at).reverse.first(num) }
  scope :all_recent_first, -> { order(:created_at).reverse }

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }   # There's a gem for this...
  validates_with BoardValidator   # validators/board_validator
 
  def tiles
    @tiles || @tiles = self.width * self.height
  end


  #
  # Generate the board grid
  #

  # Create empty grid
  # If the density of mines is > 50%, we initialize the board to be full of mines
  # and then clear the required number of tiles. This reduces how many tiles we
  # have to 'place', and also the collision rate for naive placement.
  def create_grid
    board_color = self.mines > (tiles / 2) ? true : false

    # Postgres array fields can be multidimensional, but since we're just
    # placing mines randdomly, it's easier to deal with 1d, and only worry about
    # coverting to 2d in the render
    # self.grid = Array.new(self.height){Array.new(self.width, board_color)}
    grid = Array.new(tiles, board_color)  
                                
    n = board_color ? (tiles - self.mines) : self.mines

    self.grid = set_tiles_set(grid, n, !board_color)
  end


  # Use a set to keep track of allocated mines.
  # More correct in some ways, but actually slower than naive allocation, since
  # inserting items in the set is subject to collision as the hash gets fuller.
  def set_tiles_set(grid, num, color)
    set = Set.new
    while num > 0
      tile = Random.rand(tiles)
      if not set.include?(tile)
        set.add(tile)
        grid[tile] = color
        num -= 1
      end
    end
    grid
  end


  def set_tiles_randomized_heap_or_queue_or_linked_list(grid, num, color)
    # I mean, we could ...
  end


  # this can be sped up a lot, perhaps just store chars directly in the db
  # or just serve the raw array to be rendered on the client, etc
  # should prob. go in view model or whatever
  def render_grid()
    grid = self.grid
    render = ""
    t = 0

    self.height.times do
      render << "\n" if t > 0   # we don't want leading \n
      self.width.times do
        c = grid[t] ? '💣' : '◻'
        render << c
        t += 1
      end
    end
    render
  end

end
