require 'byebug'
class PerHourIntervalGenerator < FeeGenerator
    FEE = {
        "motorcycle_scooter": [
            {
                start_time: 0,
                end_time: 4,
                fee: 30
            },
            {
                start_time: 4,
                end_time: 12,
                fee: 60
            },
            {
                start_time: 12,
                end_time: Float::INFINITY,
                fee: 100
            }
        ],
        "car_suv": [
            {
                start_time: 0,
                end_time: 4,
                fee: 60
            },
            {
                start_time: 4,
                end_time: 12,
                fee: 120
            },
            {
                start_time: 12,
                end_time: Float::INFINITY,
                fee: 200
            }
        ]
    }
    
    def self.generate(in_time, out_time, vehicle_type)
        total = ((out_time-in_time)/3600)
        charges = 0
        FEE[vehicle_type.to_sym].each do |fee|
            if(total >= fee[:start_time])
                if fee[:end_time] == Float::INFINITY
                    charges+=(total - fee[:start_time]).ceil*fee[:fee]
                    break;
                else
                    charges+=fee[:fee]
                end
            end
            
        end
        return charges
    end
    
end