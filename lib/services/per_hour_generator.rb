class PerHourGenerator < FeeGenerator
    FEE = {
        "motorcycle_scooter": 10,
        "car_suv": 20,
        "bus_truck": 50
    }
    
    def self.generate(in_time, out_time, vehicle_type)
        return ((out_time-in_time)/3600).ceil*FEE[vehicle_type.to_sym]
    end
    
end