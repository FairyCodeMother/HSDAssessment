# spec/factories.rb
require 'factory_bot'
require 'faker'

FactoryBot.define do

  # Define list of chauffeurs
  chauffeurs_array = [
    { home_address: '1201 S Lamar Blvd, Austin, TX' },
    { home_address: '11711 Argonne Forest Trail, Austin, TX' },
    { home_address: '2200 S IH 35 Frontage Rd, Austin, TX' },
    { home_address: '5801 Burnet Rd, Austin, TX' },
  ]
  factory :chauffeur do
    # Default attributes
    sequence(:id) { |n| "c#{SecureRandom.uuid}" }
    home_address { "501 West 6th St, Austin, TX" }

    # Create Chauffeurs from list
    trait :from_array do
      transient { chauffeurs { chauffeurs_array } }

      after(:create) do |chauffeur, evaluator|
        evaluator.chauffeurs.each do |chauffeur_attributes|
          create(:chauffeur, chauffeur_attributes)
        end
      end

    end
  end

  # Define list of rides
  rides_array = [
    { pickup_address: '4700 West Guadalupe, Austin, TX', dropoff_address: '3600 Presidential Blvd, Austin, TX'},
    { pickup_address: '156 W Cesar Chavez St, Austin, TX', dropoff_address: '3107 E 14th 1/2 St, Austin, TX' },
    { pickup_address: '2325 San Antonio St, Austin, TX', dropoff_address: '4000 S IH 35 Frontage Rd, Austin, TX' },
    { pickup_address: '2401 E 6th St, Austin, TX', dropoff_address: '11706 Argonne Forst Trail, Austin, TX'}
  ]
  # Initialize index to iterate through rides_array sequentially
  rides_index = 0

  factory :ride do
    # Default attributes
    sequence(:id) { |n| "r#{SecureRandom.uuid}" }
    pickup_address { rides_array[rides_index][:pickup_address] }
    dropoff_address { rides_array[rides_index][:dropoff_address] }
    ride_minutes { Faker::Number.decimal(l_digits: 1, r_digits: 2).to_f } # Placeholder
    ride_miles { Faker::Number.decimal(l_digits: 1, r_digits: 2).to_f }   # Placeholder
    ride_earnings { Faker::Number.decimal(l_digits: 2, r_digits: 2).to_f }

    # Increment index for the next ride
    after(:create) do |ride|
      rides_index = (rides_index + 1) % rides_array.size
    end

    # Create Rides from list
    trait :from_array do
      transient { rides { rides_array } }

      after(:create) do |ride, evaluator|
        evaluator.rides.each_with_index do |ride_attributes, index|
          pickup = ride_attributes[:pickup_address]
          dropoff = ride_attributes[:dropoff_address]

          calculator = CalculatorService.new
          route_metrics = calculator.calculate_route_metrics(pickup, dropoff)
          ride_earnings = calculator.calculate_earnings(route_metrics[:miles], route_metrics[:minutes])

          ride.update(
            pickup_address: pickup,
            dropoff_address: dropoff,
            ride_minutes: route_metrics[:minutes],
            ride_miles: route_metrics[:miles],
            ride_earnings: ride_earnings
          )
        end
      end
    end
  end

  factory :trip do
    sequence(:id) { |n| "t#{SecureRandom.uuid}" }

    # Use association to create chauffeur with specific home_address
    association :chauffeur, factory: [:chauffeur, home_address: '1201 S Lamar Blvd, Austin, TX']

    # Use association to create ride with specific pickup_address and dropoff_address
    association :ride, factory: [:ride, pickup_address: '2401 E 6th St, Austin, TX', dropoff_address: '11706 Argonne Forst Trail, Austin, TX']
  end


end
