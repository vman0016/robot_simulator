require 'test_helper'

class RobotTest < ActiveSupport::TestCase
  def setup
    @robot = Robot.new
  end

  test 'should discard all command until current position is valid' do
    @robot.command('REPORT')
    assert_equal(nil, @robot.current_position)
    @robot.command('MOVE')
    assert_equal(nil, @robot.current_position)
    @robot.command('LEFT')
    assert_equal(nil, @robot.current_position)
    @robot.command('RIGHT')
    assert_equal(nil, @robot.current_position)
    @robot.command('PLACE 6,6,NORTH')
    assert_equal(nil, @robot.current_position)
  end

  test 'place command should place the robot only when it\'s within boundary' do
    valid_position1 = Robot::Position.new(0,0,'NORTH')
    valid_position2 = Robot::Position.new(5,5,'NORTH')
    invalid_position1 = Robot::Position.new(5,6,'WEST')
    invalid_position2 = Robot::Position.new(6,5,'NORTH')
    invalid_position3 = Robot::Position.new(6,6,'SOUTH')

    @robot.command("PLACE #{invalid_position1}")
    assert_equal(nil, @robot.current_position)

    @robot.command("PLACE #{valid_position1}")
    assert_equal(valid_position1.to_s, @robot.current_position.to_s)

    @robot.command("PLACE #{valid_position2}")
    assert_equal(valid_position2.to_s, @robot.current_position.to_s)

    @robot.command("PLACE #{invalid_position2}")
    assert_equal(valid_position2.to_s, @robot.current_position.to_s)

    @robot.command("PLACE #{invalid_position3}")
    assert_equal(valid_position2.to_s, @robot.current_position.to_s)
  end

  test 'move command should move the robot to a valid position' do
    @robot.command('PLACE 0,0,NORTH')
    @robot.command('MOVE')
    assert_equal('0,1,NORTH', @robot.current_position.to_s)

    @robot.command('PLACE 1,1,WEST')
    @robot.command('MOVE')
    assert_equal('0,1,WEST', @robot.current_position.to_s)

    @robot.command('PLACE 0,0,WEST')
    @robot.command('MOVE')
    assert_equal('0,0,WEST', @robot.current_position.to_s)

    @robot.command('PLACE 5,5,EAST')
    @robot.command('MOVE')
    assert_equal('5,5,EAST', @robot.current_position.to_s)
  end

  test 'left command should roate the robot' do
    @robot.command('PLACE 0,0,NORTH')

    @robot.command('LEFT')
    assert_equal('0,0,WEST', @robot.current_position.to_s)

    @robot.command('LEFT')
    assert_equal('0,0,SOUTH', @robot.current_position.to_s)

    @robot.command('LEFT')
    assert_equal('0,0,EAST', @robot.current_position.to_s)

    @robot.command('LEFT')
    assert_equal('0,0,NORTH', @robot.current_position.to_s)
  end

  test 'right command should roate the robot' do
    @robot.command('PLACE 0,0,NORTH')

    @robot.command('RIGHT')
    assert_equal('0,0,EAST', @robot.current_position.to_s)

    @robot.command('RIGHT')
    assert_equal('0,0,SOUTH', @robot.current_position.to_s)

    @robot.command('RIGHT')
    assert_equal('0,0,WEST', @robot.current_position.to_s)

    @robot.command('RIGHT')
    assert_equal('0,0,NORTH', @robot.current_position.to_s)
  end
end
