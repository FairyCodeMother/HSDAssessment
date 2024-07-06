# My Notes

**Definitions:**
- A `Ride` has a unique id, a start address and a destination address. (We may end up adding additional information).
- A `Driver` has a unique id and a home address.
- The `driving distance` between two addresses is the distance in miles that it would take to drive a reasonably efficient route between them. It is not the straight line distance. It can be calculated by using a routing service
- The `driving duration` between two addresses is the amount of time in hours it would take to drive the driving distance under realistic driving conditions. It can be calculated by using a routing service
- The `commute distance` for a ride is the driving distance from the driver’s home address to the start of the ride, in miles
- The `commute duration` for a ride is the amount of time it is expected to take to drive the commute distance, in hours.
- The `ride distance` for a ride is the driving distance from the start address of the ride to the destination address, in miles
- The `ride duration` for a ride is the amount of time it is expected to take to drive the ride distance, in hours
- The `ride earnings` is how much the driver earns by driving the ride. It takes into account both the amount of time the ride is expected to take and the distance. 
  - For the purposes of this exercise, it is calculated as: $12 + $1.50 per mile beyond 5 miles + (`ride duration`) * $0.70 per minute beyond 15 minutes

------------

*I spent over a day fighting Ruby and Rails version issues. I spent too much time un/re-installing a variety of things (eg: Ruby, XCode tools, OpenSSL, Homebrew, RVM, etc), trying the solution here ([OpenSSL error installing Ruby](https://johnskinnerportfolio.com/blog/ruby_330_error.html)), and so much more trying to force Ruby 3+/Rails 7+ into the project. In the end, I decided to just make a Docker'ed project and bypass the issue. There's nothing in the assignment about containerizing, so I hope this direction is acceptable.*



### Gina's Notes:

 1. Set Up the Rails Project:
    - Ensure the Rails project HopSkipChallenge is created and Dockerized.
    - Ensure necessary gems are included in the Gemfile (e.g., rails, pg, rspec-rails).
 2. Configure the Database:
    - Set up PostgreSQL as the database.
    - Create necessary tables (drivers, rides, etc.) with appropriate fields.
 3. Set Up Google Directions API:
    - Integrate Google Directions API.
    - Implement a service to handle API requests and responses.
 4. Model Definitions:
    - Define Driver and Ride models with necessary relationships and validations.
 5. Internal Scoring System:
    - Implement the scoring algorithm to calculate the ride score.
    - Ensure the algorithm considers ride earnings, commute duration, and ride duration.
 6. API Endpoint Implementation:
    - Create a RESTful API endpoint to return the paginated JSON list of rides.
    - Implement logic to order rides by score in descending order for a given driver.
 7. Caching Mechanism:
    - Implement caching to reduce duplicate API calls to Google Directions API.
 8. RSpec Tests:
    - Set up RSpec and write tests for models, services, and API endpoints.
 9. Docker Configuration:
    - Ensure Docker configuration is properly set up for the Rails app, including dependencies.

**Proposed Directory/File Structure**
```
HopSkipChallenge/
├── app/
│   ├── controllers/
│   │   ├── api/
│   │   │   └── rides_controller.rb
│   │   └── application_controller.rb
│   ├── models/
│   │   ├── driver.rb
│   │   └── ride.rb
│   ├── services/
│   │   └── google_directions_service.rb
│   ├── serializers/
│   │   └── ride_serializer.rb
│   └── views/
├── config/
│   ├── initializers/
│   │   └── google_directions.rb
│   ├── routes.rb
│   └── database.yml
├── db/
│   ├── migrate/
│   ├── schema.rb
│   └── seeds.rb
├── spec/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           └── rides_controller_spec.rb
│   ├── models/
│   │   ├── driver_spec.rb
│   │   └── ride_spec.rb
│   ├── services/
│   │   └── google_directions_service_spec.rb
│   ├── serializers/
│   │   └── ride_serializer_spec.rb
│   └── spec_helper.rb
├── Dockerfile
├── docker-compose.yml
├── Gemfile
└── Gemfile.lock
```



