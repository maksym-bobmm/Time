# frozen_string_literal: true

# time service allows add time
module TimeService
  # calculate and store time
  class TimeCalculator
    DAY_IN_MINUTES = 1440

    def convert_to_minutes(time_input)
      @minutes = time_input[:hours] * 60
      @minutes += time_input[:minutes]

    end

    def convert_from_minutes
      hours = @minutes / 60
      minutes = @minutes % 60
      { hours: hours, minutes: minutes }
    end

    def minutes_add(minute)
      @minutes += minute
      @minutes %= DAY_IN_MINUTES if @minutes > DAY_IN_MINUTES
    end
  end

  # validate and control input/output
  class TimeParser < TimeCalculator
    attr_accessor :time_input, :minutes_to_add

    def check_args
      return if ARGV.length == 3

      puts 'Wrong arguments number (expected 2)'
      exit
    end

    def initialize(&block)
      return unless block_given?

      instance_eval(&block)
      add_minutes
    end

    def add_minutes(time_input = nil, minutes_to_add = nil)
      @time_input = time_input if time_input
      @minutes_to_add = minutes_to_add if minutes_to_add
      time = parse_input
      convert_to_minutes(time)
      minutes_add(@minutes_to_add)
      print
    end

    private

    # def main
    #   check_args
    #   # time = parse_time
    #   convert_to_minutes(time)
    #   print
    # end

    def parse_input
      return unless validate_time

      parse_format
      parse_time
    end

    def parse_format
      @time_format = @time_input.split(' ')[1]
    end

    def parse_time
      time_input = @time_input.split(':')
      hours = @time_format == 'AM' ? time_input[0].to_i : time_input[0].to_i + 12
      minutes = time_input[1].to_i
      { hours: hours, minutes: minutes }
    end

    def validate_time
      false unless @time_input.include?(':') && @time_input.include?(' ')

      tested_time = @time_input.split(':')
      tested_time[1] = tested_time[1].split
      tested_time.flatten!

      false unless tested_time[0].to_i.to_s == tested_time[0]

      false unless tested_time[1].to_i.to_s == tested_time[1]

      false unless %w[AM PM].include?(tested_time[2].upcase)

      true
    end

    def print
      time = convert_from_minutes
      @time_format = time[:hours] > 12 ? 'PM' : 'AM'
      time_hours = @time_format == 'AM' ? time[:hours] : time[:hours] % 12
      time_minutes = time[:minutes] < 10 ? "0#{time[:minutes]}" : time[:minutes]
      puts "#{time_hours}:#{time_minutes} #{@time_format}"
    end
  end

end

TimeService::TimeParser.new.add_minutes('11:12 PM', 360)
# TimeService::TimeParser.new do
#   @time_input = '12:58 AM'
#   @minutes_to_add = 3700
# end
