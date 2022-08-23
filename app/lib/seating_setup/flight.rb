require 'json'
module SeatingSetup
  class Flight
    attr_accessor :seat_setup, :seats, :passenger_count, :seats_length
    def initialize seat_setup, passenger_count
      @seat_setup = seat_setup
      @passenger_count = passenger_count
      @seats_length = seat_setup.length
      @aisle_count = 0
      @middle_count = nil
      @window_count = nil
      @output = ''
      @seats = []
      setup_seats(passenger_count,0)
    end

    def print_output
      puts "\Setup\n"
      puts @output
    end

    private
    def setup_seats(count, type, counter = 0)
      total = 0
      while seats_length > counter
        if type == 0
          seats.push(Array.new(seat_setup[counter][1]){Array.new( seat_setup[counter][0] ) { '[]' } })
        else
          total = conditions(counter, type, seats_length-1 == counter)
        end
        counter += 1
      end
      count -= total
      if count > 0 && type < 4
        return setup_seats(count, type+=1)
      else
        max_col = seat_setup.collect {|x| x[1]}.max
        populate_seats(max_col)
      end
    end
    # to populate the seats
    def populate_seats max_col, y_counter = 0
      while max_col > y_counter
        x_counter = 0
        while seats_length > x_counter
          #populate aisle seats
          seated_passenger_aisle_count = populate_aisle_seat(seated_passenger_aisle_count ||= 1, y_counter, x_counter)
          #populate middle seats
          if !@middle_count.nil?
            seated_passenger_middle_count = populate_middle_seat(seated_passenger_middle_count ||= @aisle_count + 1, y_counter, x_counter)
          end
          #populate window seats
          if !@window_count.nil?
            seated_passenger_window_count = populate_window_seat(seated_passenger_window_count ||= @aisle_count + @middle_count + 1, y_counter, x_counter)
          end
          set_output(x_counter, y_counter)
          x_counter += 1
        end
        @output += "\n"
        y_counter += 1
      end
      return @output
    end
    # conditions to identy each type of seat - aisle(1), middle(2), window(3)  
    def conditions counter, type, is_last
      # aisle
      if type === 1
        if counter == 0 || counter == seats_length - 1 
          @aisle_count += seat_setup[counter][1]
        else
          multiplier = seat_setup[counter][1] > 1 ? 2 : 1
          @aisle_count += seat_setup[counter][1] * multiplier
        end
        return @aisle_count if is_last
      # middle
      elsif type === 2
        if seat_setup[counter][0] > 2
          @middle_count ||= 0 
          @middle_count += (seat_setup[counter][0] - 2) * seat_setup[counter][1]
        end
        return @middle_count if is_last
      # window 
      elsif type === 3
        @window_count ||= 0
        @window_count += seat_setup.first[1]
        @window_count += seat_setup.last[1]
        return @window_count if is_last
      else
        return 0
      end
    end
    # for aisle seats
    def populate_aisle_seat seated_passenger_aisle_count, y_counter, x_counter
      if seated_passenger_aisle_count <= passenger_count && seated_passenger_aisle_count <= @aisle_count
        if x_counter == 0 && !seats[x_counter][y_counter].nil?
          if seats[x_counter][y_counter].length > 1
            seats[x_counter][y_counter][seats[x_counter][y_counter].length-1] = seated_passenger_aisle_count
            seated_passenger_aisle_count += 1
          end
        elsif x_counter == seats_length - 1 && !seats[x_counter][y_counter].nil?
          if seats[x_counter][y_counter].length > 1
            seats[x_counter][y_counter][0] = seated_passenger_aisle_count
            seated_passenger_aisle_count += 1
          end
        else
          if !seats[x_counter][y_counter].nil? 
            seats[x_counter][y_counter][0] = seated_passenger_aisle_count
            seated_passenger_aisle_count += 1
            if seats[x_counter][y_counter].length > 1
              seats[x_counter][y_counter][seats[x_counter][y_counter].length-1] = seated_passenger_aisle_count
              seated_passenger_aisle_count += 1
            end
          end
        end
      end
      return seated_passenger_aisle_count
    end
    # for middle seats
    def populate_middle_seat seated_passenger_middle_count, y_counter, x_counter
      if seat_setup[x_counter][0] > 2
        z_counter = 1
        while seat_setup[x_counter][0] - 1  > z_counter
          if seated_passenger_middle_count <= passenger_count
            if !seats[x_counter][y_counter].nil?
              seats[x_counter][y_counter][z_counter] = seated_passenger_middle_count
              seated_passenger_middle_count += 1
            end
          end
          z_counter += 1
        end
      end
      return seated_passenger_middle_count
    end
    # for window seats
    def populate_window_seat seated_passenger_window_count, y_counter, x_counter
      if x_counter == 0 || x_counter == seats_length - 1
        if seated_passenger_window_count <= passenger_count
          if !seats[x_counter][y_counter].nil?
            index = x_counter == 0 ? x_counter : seat_setup.last[0] - 1       
            seats[x_counter][y_counter][index] = seated_passenger_window_count
            seated_passenger_window_count += 1
          end
        end
      end
      return seated_passenger_window_count
    end
    # to set the output
    def set_output x_counter, y_counter
      if !seats[x_counter][y_counter].nil?
        @output += format_output(seats[x_counter][y_counter])
      else 
        formated = format_output(seats[x_counter][0])
        @output += "".prepend(" " * formated.length)
      end
      @output += '   |   '
    end

    def format_output data
      formated = data.collect do |item|
        item.to_s.center(@passenger_count.to_s.length+4)
      end
      return formated.join(' - ')
    end
  end
end
