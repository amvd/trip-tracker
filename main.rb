require './trip_tracker'

puts "Arguments: #{ARGV}"

def main
  trip_tracker = TripTracker.new

  puts 'File not specified. Attempting to use ./input.txt' unless ARGV[0]
  input_file = ARGV[0] || './input.txt'

  IO.foreach(input_file) do |input|
    trip_tracker.process_input(input)
  end

  trip_tracker.print_driving_report
rescue Errno::ENOENT
  puts "File #{input_file} was not found."
end

main
