#require_relative './parking_building'

class StadiumParkingBuilding < ParkingBuilding 
    
    # If we want to restrict bus, truck slots to 0, we can override here
    # def initialize(cycle_scooter=0, car_suv=0)
    #     @slot_info[:cycle_scooter] = cycle_scooter
    #     @slot_info[:car_suv] = car_suv
    # end

    def fee_model
        "PerHourInterval"
    end
end