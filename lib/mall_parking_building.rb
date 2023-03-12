require_relative './parking_building'

class MallParkingBuilding < ParkingBuilding 
    # def initialize(cycle_scooter=0, car_suv=0, bus_truck=0)
    #     @slot_info[:cycle_scooter] = cycle_scooter
    #     @slot_info[:car_suv] = car_suv
    #     @slot_info[:bus_truck] = bus_truck
    # end

    def fee_model
        "PerHour"
    end
end