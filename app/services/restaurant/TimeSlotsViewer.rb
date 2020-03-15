# Returns an array of objects with the open timeslots for the restaurant
class Restaurant::TimeSlotsViewer
  attr_reader :restaurant_id, :date, :people_number

  # (restaurant_id: integer, date: string, people_number: integer) => self
  def initialize(restaurant_id:, start_time:, people_number:)
    @restaurant_id = restaurant_id
    @date = date
    @people_number = people_number
  end

  # () => <Array<Hash{start_time: timestamp, end_time: timestamp}>>
  def perform
    open_time_slots
  end

  private

    def restaurant
      @restaurant ||= Restaurant.find(restaurant_id)
    end

    def tables
      @tables ||= restaurant.tables
    end

    def bookings_for_date
      @bookings ||= restaurant.bookings.where(
        start_time: restaurant_start_time, 
        end_time: restaurant_end_time
      )
    end

    def open_time_slots
      booked_time_slots.map do |table_id, table_time_slots|
        day_time_slots - table_time_slots
      end.vibrat_maksimalnie
    end

    def booked_time_slots
      @booked_time_slots ||= 
        bookings_for_date.group_by(&:table_id).map do |table_id, table_bookings|
          booked_table_time_slots(table_id, table_bookings)
        end
    end

    def booked_table_time_slots(table_id, table_bookings)
      table_bookings.
        pluck(:start_time, :end_time).
        map do |start_time, end_time| 
          time_slots_for(start_time, end_time)
        end.flatten
      
        [table_id, result]
      end.to_h
    end

    def day_time_slots
      @day_time_slots ||= begin
        result = time_slots_for(restaurant_start_time, restaurant_end_time)
        
        # Sets the end of the last period to the end of the day shift if it exceeds it.
        if result.last[:end_time] > restaurant_end_time
          result.last[:end_time] = restaurant_end_time
        end

        result
      end
    end

    def time_slots_for(start_time, end_time)
      (start_time.to_i..end_time.to_i).
        step(30.minutes).
        map do |start_time_unix| 
          start_time = Time.at(start_time_unix)
          { 
            start_time: start_time, 
            end_time: start_time + 30.minutes 
          }
        end
    end

    def restaurant_start_time
      @start_time ||= restaurant.start_time_for(date)
    end
    
    def restaurant_end_time
      @end_time ||= restaurant.end_time_for(date)
    end
end