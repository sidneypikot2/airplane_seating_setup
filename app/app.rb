require_relative 'lib/seating_setup'

puts 'Input a 2D array that represents an airplane seating arrangement - Ex. [[3,3], [5,4], [7,3]]:'
seat_setup = JSON.parse(gets.chomp)
puts 'Input number of passengers in queue:'
passenger_count = gets.chomp
flight_seats = SeatingSetup::Flight.new(seat_setup, passenger_count.to_i)
output = flight_seats.setup_seats
puts output
