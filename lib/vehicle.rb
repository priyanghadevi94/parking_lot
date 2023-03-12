class Vehicle

    attr_accessor :vehicle_type, :in_time, :out_time, :slot_id, :token

    def initialize(in_time,vehicle_type)
        self.in_time = in_time
        self.vehicle_type = vehicle_type
    end
end