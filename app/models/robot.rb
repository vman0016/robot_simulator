class Robot
  attr_reader :current_position

  DIRECTIONS = %w(north east south west).freeze

  Position = Struct.new(:x, :y, :dir) do
    def to_s
      "#{x},#{y},#{dir.upcase}"
    end
  end
  Boundary = Struct.new(:x, :y)

  def initialize(boundary = Boundary.new(5, 5))
    @current_position = nil
    @boundary = boundary
  end

  def command(instruction)
    return if instruction.empty?

    command, arguments = instruction.split(' ', 2)
    command.downcase!
    # ignore command until the robot is placed
    return if @current_position.nil? && command != 'place'

    case command
    when 'place'
      x, y, dir = arguments.split(',').map(&:strip)
      place(x, y, dir)
    when 'move'
      move
    when 'left'
      rotate(-1)
    when 'right'
      rotate(1)
    when 'report'
      report
    else
      raise "not supported command: #{command}"
    end
  rescue => e
    Rails.logger.error(e.message)
    raise "invalid command: #{instruction}"
  end

  private
  def valid_position?(x, y)
    return false if x < 0 || x > @boundary.x
    return false if y < 0 || y > @boundary.y

    true
  end

  def place(x, y, dir)
    x = x.to_i
    y = y.to_i
    return unless valid_position?(x, y)
    dir.downcase!
    return unless DIRECTIONS.include?(dir)

    @current_position ||= Position.new
    @current_position.x = x
    @current_position.y = y
    @current_position.dir = dir
  end

  def move
    return if @current_position.nil?

    case @current_position.dir
    when 'north'
      new_y = @current_position.y + 1
    when 'south'
      new_y = @current_position.y - 1
    when 'east'
      new_x = @current_position.x + 1
    when 'west'
      new_x = @current_position.x - 1
    end

    new_x ||= @current_position.x
    new_y ||= @current_position.y
    return unless valid_position?(new_x, new_y)

    # move to the new position
    @current_position.x = new_x
    @current_position.y = new_y
  end

  def report
    puts "Output: #{@current_position}"
  end

  # rotate by, positive: clockwise, negative: anti-clockwise
  def rotate(by = 1)
    return if @current_position.nil?
    index = DIRECTIONS.index(@current_position.dir)
    index = (index + by) % DIRECTIONS.length
    @current_position.dir = DIRECTIONS[index]
  end

end
