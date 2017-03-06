# Represents trip taken by driver
class Trip
  attr_reader :start_time, :stop_time, :distance, :speed
  def initialize(start_time, stop_time, distance, speed)
    @start_time = start_time
    @stop_time = stop_time
    @distance = distance
    @speed = speed
  end
end
