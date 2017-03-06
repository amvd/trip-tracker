# Registers new drivers and logs trips
class TripTracker
  ENTRY_TYPES = %w(Driver Trip).freeze

  def initialize
    @drivers = []
  end

  def process_input(input_str)
    entry_array = parse_input(input_str)

    entry_type, entry_data = process_entry(entry_array)

    if 'Driver' == entry_type
      create_driver(entry_data.first)
    elsif 'Trip' == entry_type
      log_trip(entry_data)
    else
      puts "Cannot process entry of type #{entry_type}."
    end
  end

  def print_driving_report
    sort_drivers_by_miles_driven!

    @drivers.each do |driver|
      output = "#{driver.name}: #{driver.total_distance.to_i} miles"

      output += " @ #{driver.average_speed.to_i} mph" if driver.average_speed

      puts output
    end
  end

  private

  def process_entry(entry_array)
    entry_type, *entry_data = entry_array
    return entry_type, entry_data
  end

  def parse_input(input)
    input.split
  end

  def create_driver(data)
    @drivers << Driver.new(data)
  end

  def log_trip(data)
    driver_name, *trip_info = data

    driver = fetch_driver(driver_name)

    start = trip_info[0]
    stop = trip_info[1]
    distance = trip_info[2].to_f
    duration = get_duration(start, stop)
    speed = distance / duration

    return if 5 > speed || 100 < speed

    driver.add_trip(start, stop, distance, speed)
  end

  def fetch_driver(name)
    driver = @drivers.detect { |d| name == d.name }
    if driver
      driver
    else
      puts "Could not find driver #{name}."
    end
  end

  def get_duration(start_time, stop_time)
    [stop_time, start_time].map!(&method(:convert_time_to_float)).reduce(&:-)
  end

  def convert_time_to_float(time_string)
    time_arr = time_string.split(':').map(&:to_i)
    time_arr[1] = time_arr[1] / 60.to_f
    time_arr.reduce(&:+)
  end

  def sort_drivers_by_miles_driven!
    @drivers.sort! do |d1, d2|
      d2.total_distance <=> d1.total_distance
    end
  end
end

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

trip_tracker = TripTracker.new

IO.foreach('input.txt') do |input|
  trip_tracker.process_input(input)
end

trip_tracker.print_driving_report
