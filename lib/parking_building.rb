class UserError < StandardError; end

Dir["./lib/services/*.rb"].each {|file| require file }


#Dir['./services/*.rb'].each { |f| require_relative(f) } 
require 'byebug'
class ParkingBuilding
 attr_accessor :slot_info, :slots

    def initialize(motorcycle_scooter=0, car_suv=0, bus_truck=0)
        @slot_info ={}
        @slot_info[:motorcycle_scooter] = motorcycle_scooter
        @slot_info[:car_suv] = car_suv
        @slot_info[:bus_truck] = bus_truck
        initialize_slots()
    end

    def initialize_slots
        @slots ={}
        @slot_info.each{|key,value| @slots[key]=Array.new(value) if value>0}
    end

    def park(vehicle_type, in_time = Time.now)
        vehicle_type = get_type(vehicle_type)
        @vehicle = Vehicle.new(in_time, vehicle_type)
        @vehicle.slot_id  = find_slots(vehicle_type)
        @vehicle.token = "ABC#{vehicle_type[0].upcase}#{@vehicle.slot_id}"
        @slots[vehicle_type.to_sym][@vehicle.slot_id]=@vehicle
        puts "entrytime #{in_time.strftime("%y-%m-%d %H:%m")}, slot id #{@vehicle.slot_id} and token #{@vehicle.token}"
        {
            token:  @vehicle.token,
            slot_id: @vehicle.slot_id,
            in_time: @vehicle.in_time
        }
    end

    def unpark(token, out_time_interval)
        @vehicle = @slots.values.flatten.find{|a| a&.token == token}
        raise UserError, "No such Vehicle" if @vehicle.nil?
        @vehicle.out_time = @vehicle.in_time+out_time_interval
       
        
        @slots[@vehicle.vehicle_type.to_sym][@vehicle.slot_id] = nil
        charges = calculate_charges(@vehicle)
        puts "entrytime #{@vehicle.in_time.strftime("%y-%m-%d %H:%m")}, slot id #{@vehicle.slot_id} and token #{@vehicle.token} and Total charge Rs.#{charges} , out time #{@vehicle.out_time.strftime("%y-%m-%d %H:%m")}"
        {
            token:  @vehicle.token,
            slot_id: @vehicle.slot_id,
            in_time: @vehicle.in_time,
            out_time: @vehicle.out_time,
            charges: charges
        }
    end

    def find_slots(vehicle_type)
        raise UserError, "no parking for #{vehicle_type}" if @slot_info[vehicle_type.to_sym] == 0 
        @slots[vehicle_type.to_sym].each_with_index do |slot, index|
             return index if slot.nil?
          end
            raise UserError, "Parking full for #{vehicle_type}"
    end

    
    def calculate_charges(vehicle)
        Object.const_get((fee_model+"Generator")).generate(vehicle.in_time, vehicle.out_time, vehicle.vehicle_type)
    end

    def get_type(type)
        {
            "car": "car_suv",
            "suv": "car_suv",
            "motorcycle": "motorcycle_scooter",
            "scooter": "motorcycle_scooter",
            "bus": "bus_truck",
            "truck": "bus_truck"
        }[type.to_sym]
    end
end