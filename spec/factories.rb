# spec/factories.rb
require 'factory_bot'

FactoryBot.define do
  # Define a list of chauffeurs
  chauffeurs_array = [
    { home_address: '1201 S Lamar Blvd, Austin, TX' },
    { home_address: '11711 Argonne Forest Trail, Austin, TX' },
    { home_address: '2200 S IH 35 Frontage Rd, Austin, TX' },
    { home_address: '5801 Burnet Rd, Austin, TX' },
  ]

  factory :chauffeur do
    sequence(:id) { |n| "c#{SecureRandom.uuid}" }

    # Set a default to start with
    home_address { "501 West 6th St, Austin, TX" }

    # Create chauffeurs from the array
    trait :from_array do
      transient do
        chauffeurs { chauffeurs_array }
      end

      after(:create) do |chauffeur, evaluator|
        evaluator.chauffeurs.each do |chauffeur_attributes|
          create(:chauffeur, chauffeur_attributes)
        end
      end
    end
  end


  # rides = [
  #   { pickup_address: '2401 E 6th St, Austin, TX', dropoff_address: '11706 Argonne Forst Trail, Austin, TX' },
  #   { pickup_address: '4700 West Guadalupe, Austin, TX', dropoff_address: '3600 Presidential Blvd, Austin, TX'},
  #   { pickup_address: '156 W Cesar Chavez St, Austin, TX', dropoff_address: '3107 E 14th 1/2 St, Austin, TX' },
  #   { pickup_address: '2325 San Antonio St, Austin, TX', dropoff_address: '4000 S IH 35 Frontage Rd, Austin, TX' }
  # ]
  # factory :ride do
  #   pickup_address { "2401 E 6th St, Austin, TX" }
  #   dropoff_address { "11706 Argonne Forest Trail, Austin, TX" }
  # end

end
