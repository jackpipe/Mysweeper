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

    self.grid = set_tiles_naive(grid, n, !board_color)
    #self.grid = set_tiles_lfsr(grid, n, !board_color)
  end


  # Simply place mines or blanks at random, trying again if we get a collision.
  # We should get at most 50% collision rate. If for some reason we wanted a
  # lower collision rate, we could create and oversized hash of mine positions.
  def set_tiles_naive(grid, num, color)
    while num > 0
      tile = Random.rand(tiles)
      if not grid[tile] == color
        grid[tile] = color
        num -= 1
      end
    end
    grid
  end


  # A maximal lfsr has the magical property of visiting each element of a ^2 range
  # in psuedo-random order. Since there are no collisions we don't need to check
  # if a mine has already been placed in that position.
  # 
  # The disadvantage is that it's not really random - At each size of lfsr
  # we're just taking a different 'window' of that sequence depending on board size
  # and number of mines.
  # It's fairly convincing in general, but the naive allocator is probably a better
  # choice if this were used seriously.
  def set_tiles_lfsr(grid, num, color)
    # Not-at-all-optimal selection of maximal lfsr taps for 2^n where n 4..32
    lfsr_taps = [
      0,1,3,6,0x9,0x12,0x21,0x41,0x8E,0x108,0x204,0x402,0x829,0x100D,0x2015,0x4001,
      0x8016,0x10004,0x20013,0x40013,0x80004,0x100002,0x200001,0x400010,0x80000D,
      0x1000004,0x2000023,0x4000013,0x8000004,0x10000002,0x20000029,0x40000004,0x80000057 ]

    # Find the nearest power of 2 that covers how many tiles there are.
    # we need 1 more, because lfsr does not generate 0, so we need to -1 each random

    log2 = Math.log2(tiles+1).ceil    # could find this by bit-shifting, for speed
    taps = lfsr_taps[log2]
    lfsr = Random.rand(1..tiles)      # seed the lfsr. could be 1..2**log2-1

    while num > 0
      if (lfsr <= tiles)
        grid[lfsr-1] = color
        num -= 1
      end

      lfsr = ((lfsr & 1) == 0) \
        ? (lfsr >> 1)
        : (lfsr >> 1) ^ taps
    end
    grid
  end


  def set_tiles_randomized_heap_or_queue_or_linked_list(num, color)
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
