#!/usr/bin/env ruby
require './lib/parking_building'
Dir['./lib/*.rb'].each { |f| require_relative(f) }

require 'byebug'

def process_input(input)
  parking_building = nil
  input.split("\n").each do |input|
    begin
        sliced_input = input.split(/\s/)
        command = sliced_input[0]
        if  command.include?("create")
            params =  sliced_input[1].split(",").map{|a| a.to_i}
            klass = if command.include?("mall")
                MallParkingBuilding
            elsif command.include?("stadium")
                StadiumParkingBuilding
            else
                AirportParkingBuilding
            end
            parking_building = klass.new(*params)
        elsif command.include?("unpark")
        params =  sliced_input[2].split(",").map{|a| a.to_i}
        interval = params[0]*24*3600+params[1]*3600+params[2]*60
        parking_building.unpark(sliced_input[1], interval)
        else
            parking_building.park(sliced_input[1], Time.now)
        end
    rescue => e
        puts "#{e}"
        next
    end
  end
end

process_input(File.read(ARGV[0]))