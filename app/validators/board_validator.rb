class BoardValidator < ActiveModel::Validator

  MAX_HEIGHT = 1000.freeze
  MAX_WIDTH = 1000.freeze

  def validate(record)
    if record.nil?
      record.errors[:base] << "Can't be null"

    elsif not record.height.is_a?(Integer)
      record.errors.add(:height, "Dimensions must be integers")

    elsif not record.width.is_a?(Integer)
      record.errors.add(:width, "Dimensions must be integers")

    elsif record.width > MAX_WIDTH
      record.errors.add(:width, "Too big! Max #{MAX_WIDTH}.")
    elsif record.height > MAX_HEIGHT
      record.errors.add(:width, "Too big! Max #{MAX_HEIGHT}.")

    elsif record.height <= 0 or record.width <= 0 or (record.height * record.width) < 2
      record.errors.add(:height, "The board must be at least 2 tiles.")
      record.errors.add(:width, "The board must be at least 2 tiles.")

    elsif not record.mines.is_a?(Integer)
      record.errors.add(:mines, "Mines must be a number")

    elsif record.mines <= 0
      record.errors.add(:mines, "Too easy! There must be some mines.")

    else
      tiles = (record.width * record.height) - 1
      if record.mines > tiles
        record.errors.add(:mines, "Too many mines! Max #{tiles}")
      end
    end
  end
end
