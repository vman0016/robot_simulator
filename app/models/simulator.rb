class Simulator
  def initialize
    @robot = Robot.new
  end

  def read_commands_from_file(file_path)
    File.open(file_path, 'rb') do |f|
      f.each_line do |line|
        line.chomp!
        @robot.command(line) unless line.empty?
      end
    end
  end

  def read_commands_from_input
    puts "Enter commands below (enter '\\q' to quit):"
    loop do
      instruction = gets.chomp
      break if instruction == '\q'
      begin
        @robot.command(instruction)
      rescue => e
        puts "Failed: #{e.message}"
      end
    end
  end
end
