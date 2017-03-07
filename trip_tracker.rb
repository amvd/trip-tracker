require './driver'
require './trip'

# Registers new drivers and logs trips
class TripTracker
  ENTRY_TYPES = %w(Driver Trip).freeze

  def initialize
    @drivers = []
  end

  def process_input_array(input_array)
    command, *data = input_array

    if 'Driver' == command
      create_driver(data.first)
    elsif 'Trip' == command
      log_trip(data)
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

  def create_driver(name)
    if fetch_driver(name)
      puts "Driver #{name} already exists."
      return
    end
    @drivers << Driver.new(name)
  end

  def log_trip(data)
    driver_name, *trip_info = data

    driver = fetch_driver(driver_name)

    unless driver
      puts "Unable to find driver #{driver_name}."
      return
    end

    start, stop, distance = trip_info
    distance = distance.to_f

    duration = get_duration(start, stop)
    speed = distance / duration

    return if 5 > speed || 100 < speed

    driver.add_trip(start, stop, distance, speed)
  end

  def fetch_driver(name)
    @drivers.detect { |driver| name == driver.name }
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
