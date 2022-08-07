require 'json'
module SeatingSetup
  class Flight
    attr_accessor :seat_setup, :seats, :passenger_count, :seats_length
    def initialize seat_setup, passenger_count
      @seat_setup = seat_setup
      @passenger_count = passenger_count
      @seats_length = seat_setup.length
      setup_seats
    end

    def setup_seats
      counter = 0
      @seats = []
      while seat_setup.length > counter
        @seats.push(Array.new( seat_setup[counter][1] ){Array.new( seat_setup[counter][0] ) { '[]' } })
        counter += 1
      end
      set_aisles
    end
    
    private
    def set_aisles
      aisle_count = 0
      counter = 0
      while seats_length > counter
        if counter == 0 || counter == seats_length - 1 
          aisle_count += seat_setup[counter][1]
        else
          multiplier = seat_setup[counter][1] > 1 ? 2 : 1
          aisle_count += seat_setup[counter][1] * multiplier
        end
        counter += 1
      end
      if aisle_count < passenger_count
        set_middle(aisle_count)
      else
        populate_seats(aisle_count)
      end
    end
    
    def set_middle(aisle_count)
      middle_count = 0
      counter = 0
      while seats_length > counter
        if seat_setup[counter][0] > 2
          middle_count += (seat_setup[counter][0] - 2) * seat_setup[counter][1]
        end
        counter += 1
      end
      if aisle_count + middle_count < passenger_count
        set_window(aisle_count, middle_count)
      else
        populate_seats(aisle_count, middle_count)
      end
    end
    
    def set_window(aisle_count, middle_count)
      window_count = 0
      window_count += seat_setup.first[1]
      window_count += seat_setup.last[1]
      populate_seats(aisle_count, middle_count, window_count)
    end

    def populate_seats aisle_count, middle_count = nil, window_count = nil
      max_col = seat_setup.collect {|x| x[1]}.max
      y_counter = 0
      seated_passenger_aisle_count = 1
      seated_passenger_middle_count = aisle_count + 1
      seated_passenger_window_count = aisle_count + middle_count + 1
      output = ''
      while max_col > y_counter
        x_counter = 0
        while seats_length > x_counter
          #populate aisle seats
          if seated_passenger_aisle_count <= passenger_count && seated_passenger_aisle_count <= aisle_count
            if x_counter == 0 && !seats[x_counter][y_counter].nil?
              if seats[x_counter][y_counter].length > 1
                seats[x_counter][y_counter][seats[x_counter][y_counter].length-1] = seated_passenger_aisle_count
                seated_passenger_aisle_count += 1
              end
            elsif x_counter == seats_length - 1 && !seats[x_counter][y_counter].nil?
              if @seats[x_counter][y_counter].length > 1
                seats[x_counter][y_counter][0] = seated_passenger_aisle_count
                seated_passenger_aisle_count += 1
              end
            else
              if !@seats[x_counter][y_counter].nil? 
                @seats[x_counter][y_counter][0] = seated_passenger_aisle_count
                seated_passenger_aisle_count += 1
                if @seats[x_counter][y_counter].length > 1
                  @seats[x_counter][y_counter][@seats[x_counter][y_counter].length-1] = seated_passenger_aisle_count
                  seated_passenger_aisle_count += 1
                end
              end
            end
          end
          #populate middle seats
          if !middle_count.nil?
            if seat_setup[x_counter][0] > 2
              z_counter = 1
              while seat_setup[x_counter][0] - 1  > z_counter
                if seated_passenger_middle_count <= passenger_count
                  if !@seats[x_counter][y_counter].nil?
                    @seats[x_counter][y_counter][z_counter] = seated_passenger_middle_count
                    seated_passenger_middle_count += 1
                  end
                end
                z_counter += 1
              end
            end
          end
          #populate window seats
          if !window_count.nil?
            if x_counter == 0 || x_counter == seats_length - 1
              if seated_passenger_window_count <= passenger_count
                if !@seats[x_counter][y_counter].nil?
                  index = x_counter == 0 ? x_counter : seat_setup.last[0] - 1       
                  @seats[x_counter][y_counter][index] = seated_passenger_window_count
                  seated_passenger_window_count += 1
                end
              end
            end
          end
          output = set_output(output, x_counter, y_counter)
          x_counter += 1
        end
        output += "\n"
        y_counter += 1
      end
      return output
    end

    def set_output output, x_counter, y_counter
      output += !@seats[x_counter][y_counter].nil? ? @seats[x_counter][y_counter].join(' - ') : "".prepend("    " * seat_setup[x_counter][0])
      output += '   |   '
      return output
    end
  end
end
