require './lib/parking_building'
Dir['./lib/*.rb'].each { |f| require(f) }
require 'byebug'
require 'rspec'


RSpec.describe 'ParkingBuilding' do
    context 'Creates a new mall parking building and parks/unparks cars' do
        it 'returns new mall parking lot instance' do
            parking_building = MallParkingBuilding.new(2,2,3)
            expect(parking_building.slot_info[:motorcycle_scooter]).to eql(2)
            expect(parking_building.slot_info[:car_suv]).to eql(2)
            expect(parking_building.slot_info[:bus_truck]).to eql(3)
        end
    end
    
    context 'new mall parking building -  parks/unparks cars' do
        let(:parking_building) { MallParkingBuilding.new *[2,2,3] }
      
        it 'parks new car' do
            response = parking_building.park("car")
            expect(response[:token]).not_to be_empty
            expect(response[:slot_id]).to be_integer
            expect(response[:in_time]).to be_an Time
        end

        it 'raises parking full error' do
             parking_building.park("suv")
             parking_building.park("car")
             expect{parking_building.park("suv")}.to raise_exception
        end

        it 'unparks the car' do
            res_hash =  parking_building.park("suv")
            response = parking_building.unpark(res_hash[:token],calculate_inteval(0,6,1))
            expect(response[:charges]).to eq(140)
            expect(parking_building.slots[:car_suv][res_hash[:slot_id]]).to be_nil
        end   
    end

    context 'new stadium parking building -  parks/unparks cars' do
        let(:parking_building) { StadiumParkingBuilding.new *[2,2,0] }
      
        it 'parks new car' do
            response = parking_building.park("car")
            expect(response[:token]).not_to be_empty
            expect(response[:slot_id]).to be_integer
            expect(response[:in_time]).to be_an Time
        end

        it 'parks new suv' do
            response = parking_building.park("motorcycle")
            expect(response[:token]).not_to be_empty
            expect(response[:slot_id]).to be_integer
            expect(response[:in_time]).to be_an Time
        end

        it 'unparks the electric suv and checks against charges' do
            res_hash =  parking_building.park("suv")
            response = parking_building.unpark(res_hash[:token],calculate_inteval(0,13,5))
            expect(response[:charges]).to eq(580)
            expect(parking_building.slots[:car_suv][res_hash[:slot_id]]).to be_nil
        end   

        it 'unparks the motorcycle and checks against charges' do
            res_hash =  parking_building.park("motorcycle")
            response = parking_building.unpark(res_hash[:token],calculate_inteval(0,3,40))
            expect(response[:charges]).to eq(30)
            expect(parking_building.slots[:motorcycle_scooter][res_hash[:slot_id]]).to be_nil
        end   

        it 'unparks with wrong token' do
            res_hash =  parking_building.park("motorcycle")
            expect{parking_building.unpark("ABC",calculate_inteval(0,3,40))}.to raise_exception
           
        end   
    end

    context 'new stadium parking building -  parks/unparks cars' do
        let(:parking_building) { AirportParkingBuilding.new *[3,1,0] }
      
        it 'parks new car' do
            response = parking_building.park("car")
            expect(response[:token]).not_to be_empty
            expect(response[:slot_id]).to be_integer
            expect(response[:in_time]).to be_an Time
        end

        it 'parks new truck raises exception' do
            expect{parking_building.park("truck")}.to raise_exception
        end

        it 'unparks the motorcycle within one hour and expects charge is free' do
            res_hash =  parking_building.park("motorcycle")
            response = parking_building.unpark(res_hash[:token],calculate_inteval(0,0,55))
            expect(response[:charges]).to eq(0)
            expect(parking_building.slots[:motorcycle_scooter][res_hash[:slot_id]]).to be_nil
        end   

        it 'unparks the car which was parked for three days' do
            res_hash =  parking_building.park("suv")
            response = parking_building.unpark(res_hash[:token],calculate_inteval(3,1))
            expect(response[:charges]).to eq(400)
            expect(parking_building.slots[:car_suv][res_hash[:slot_id]]).to be_nil
        end   
    end

    def calculate_inteval(day=0, hour=0, minutes=0) 
        day*24*3600+hour*3600+minutes*60
    end
end