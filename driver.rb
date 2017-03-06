require './trip'

# Represents driver
class Driver
  attr_reader :name, :trips
  def initialize(name)
    @name = name
    @trips = []
  end

  def add_trip(start_time, stop_time, distance, speed)
    @trips << Trip.new(start_time, stop_time, distance, speed)
  end

  def total_distance
    return 0 if @trips.empty?
    @trips.reduce(0) do |total_distance, next_trip|
      total_distance + next_trip.distance
    end
  end

  def average_speed
    return nil if @trips.empty?
    @trips.reduce(0) do |total_distance, next_trip|
      total_distance + next_trip.speed
    end.to_f / @trips.length
  end
end