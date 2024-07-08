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

Configure Docker Compose to orchestrate the services.
Create a New Rails Application


### Gina's Notes:

 1. Set Up the Docker and Rails Project
    - Create Docker files for Ruby 3+, PostgreSQL, etc
    - Necessary gems (eg: Rails 7+)
    - Configure to use PostgreSQL
 2. Model Design and Definitions
    - Define the Ride and Driver tables and models
    - Set up associations
    - Define Driver and Ride models with necessary relationships and validations
    - Seed file with Faker Gem
 3. Set Up Google Directions API
    - Integrate Google Directions API.
    - Implement a service to handle API requests and responses.
 4. Internal Scoring System
    - Implement the scoring algorithm to calculate the ride score.
    - Ensure the algorithm considers ride earnings, commute duration, and ride duration.
 5. API Endpoint Implementation:
    - Create a RESTful API endpoint to return the paginated JSON list of rides.
    - Implement logic to order rides by score in descending order for a given driver.
 6. Caching Mechanism:
    - Implement caching to reduce duplicate API calls to Google Directions API.
 7. RSpec Tests:
    - Set up RSpec and write tests for models, services, and API endpoints.
 8. Docker Configuration:
    - Ensure Docker configuration is properly set up for the Rails app, including dependencies.




Set Up Models, Relationships, etc


```
// Drivers- Entity that can accept a Ride to start a Trip

docker-compose run web rails generate model Driver driver_id:string home_address:string
```
- String `:driver_id` (null: false)
  - unique identifier
- String `:home_address` (null: false)
- Timestamp `:created_at`


```
// Ride- Can be chosen by a Driver for a trip

docker-compose run web rails generate model Ride ride_id:string start_address:string destination_address:string ride_distance_miles:float ride_duration_hours:float
```
- String `:ride_id` (null: false)
  - unique identifier
- String `:start_address` (null: false)
- String `:destination_address` (null: false)
- Float `:ride_distance_miles`
  - Driving distance (in miles) from the `Ride:start_address` to `Ride:destination_address`
- Float `:ride_duration_hours`
  - Amount of time (in hours) to drive `:ride_distance_miles`
- Timestamps `:created_at` (null: false)

Trip- Created when a Driver chooses a Ride
- String `:trip_id` (null: false)
  - unique identifier
- References `:driver_id` (null: false, foreign_key: true)
- References `:ride_id` (null: false, foreign_key: true)
- Float `:commute_distance_miles`
  - Distance (miles) between `Driver:home_address` and `Ride:start_address` (calculated using routing service)
- Float `:commute_duration_hours`
  - Amount of time (in hours) to drive `:commute_distance_miles`
- Float `:trip_distance_miles`
  - `:ride_distance_miles` + `:commute_distance_miles`
- Float `:trip_duration_hours`
  - `:ride_duration_hours` + `:commute_duration_hours`
- Float `:ride_earnings`
  - Amount (in dollars and cents) the driver earns by driving the Trip
    - $12 + $1.50 per mile beyond 5 miles + (`:ride_duration`) * $0.70 per minute beyond 15 minutes


Misc
- (Float) `:driving_distance`
  - Distance (miles) between two addresses (calculated using routing service)
  - The function that derives this value will be used to populate `:ride_distance_miles` and `:commute_distance_miles`
- (Float) `:driving_duration`
  - Time (hours) to drive `:driving_distance` (calculated using routing service)
  - The function that derives this value will be used to populate `:ride_distance_hours` and `:commute_distance_hours`

-----



