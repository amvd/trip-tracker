inputs = [
  'Driver Dan',
  'Driver Alex',
  'Driver Bob',
  'Trip Dan 07:15 07:45 17.3',
  'Trip Dan 06:12 06:32 12.9',
  'Trip Alex 12:01 13:16 42.0'
]

ENTRY_TYPES = %w(Driver Trip).freeze

$drivers = []

def process_entry(entry_array)
  entry_type, *entry_data = entry_array
  return entry_type, entry_data
end

def parse_input(input)
  input.split
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

def create_driver(data)
  $drivers << Driver.new(data)
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
  driver = $drivers.detect { |driver| name == driver.name }
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
    return 0 unless @trips.length > 0
    @trips.reduce(0) { |total, next_trip| total + next_trip.distance }
  end

  def average_speed
    return 0 unless @trips.length > 0
    @trips.reduce(0) { |total, next_trip| total + next_trip.speed }.to_f / @trips.length
  end
end

class Trip
  attr_reader :start_time, :stop_time, :distance, :speed
  def initialize(start_time, stop_time, distance, speed)
    @start_time = start_time
    @stop_time = stop_time
    @distance = distance
    @speed = speed
  end
end

inputs.each do |input|
  process_input(input)
end

puts "Total Drivers: #{$drivers.length}"

sorted_drivers = $drivers.sort do |d1, d2|
  d2.total_distance <=> d1.total_distance
end

sorted_drivers.each do |driver|
  output = "#{driver.name}: #{driver.total_distance} miles"
  if driver.average_speed
    output += " @ #{driver.average_speed} mph"
  end

  puts output
end
