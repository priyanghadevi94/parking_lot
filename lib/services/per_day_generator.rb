class PerDayGenerator < FeeGenerator
    require 'byebug'

    FEE = {
        "motorcycle_scooter": [
            {
                start_time: 0,
                end_time: 1,
                fee: 0
            },
            {
                start_time: 1,
                end_time: 8,
                fee: 40
            },
            {
                start_time: 8,
                end_time: 24,
                fee: 60
            },
            {
                start_time: 24,
                end_time: Float::INFINITY,
                fee: 80
            }
        ],
        "car_suv": [
            {
                start_time: 0,
                end_time: 12,
                fee: 60
            },
            {
                start_time: 12,
                end_time: 24,
                fee: 80
            },
            {
                start_time: 24,
                end_time: Float::INFINITY,
                fee: 100
            }
        ]
    }
    
    def self.generate(in_time, out_time, vehicle_type)
      
        total = ((out_time-in_time)/3600)
        charges = 0
        if (total>=24)
            per_day_fee = FEE[vehicle_type.to_sym].find{|a| a[:end_time] == Float::INFINITY}[:fee]
           charges= (total/24).ceil*per_day_fee
        else
        
            FEE[vehicle_type.to_sym].each do |fee|
                if(total >= fee[:start_time] && total <fee[:end_time])
                    charges=fee[:fee]
                    break;
                end
                
            end
        end
        return charges
    end
    
end