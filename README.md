This is the program I have created to meet the requirements of the desired application.

The program can be run from `main.rb` and takes the filename of the input file as a parameter. If no filename is given, it will automatically look for the input file at `./input.txt`.

The interface of the TripTracker, as I have named it, is very simple. It accepts an array of input data through its `process_input_array` method, and will generate a report of driver data via `print_driving_report`. The report lists driver names with their total miles driven and average speed (when applicable), in descending order of miles driven.

I have chosen to split the input strings into an array of strings in `main.rb` instead of within TripTracker. I'm treating the array format as a sort of standard format for inputs