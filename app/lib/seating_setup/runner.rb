# require_relative 'lib/seating_setup'
module SeatingSetup
  class Runner
    def call
      seat_setup = nil
      until seat_setup.kind_of?(Array) && seat_setup.all? {|i| i.kind_of?(Array)} do
        puts 'Input a 2D array that represents an airplane seating arrangement - Ex. [[3,3], [5,4], [7,3]]:'
        seat_setup = gets.chomp
        seat_setup = seat_setup.length > 0 && seat_setup != 'nil' ? JSON.parse(seat_setup) : nil
      end
      passenger_count = ""
      until passenger_count.match(/\A[+-]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/) do
        puts 'Input number of passengers in queue:'
        passenger_count = gets.chomp
      end
      flight_seats = SeatingSetup::Flight.new(seat_setup, passenger_count.to_i)
      flight_seats.print_output
    end
  end
end