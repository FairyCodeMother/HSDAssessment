# HopSkipChallenge

HopSkipChallenge develops a RESTful API endpoint for managing Rides and Trips within a ride service app, utilizing Ruby 3 on Rails 7, integrating with Google Maps API for route calculations, and Dockerizd.

## Table of Contents

- [HopSkipChallenge](#hopskipchallenge)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Specification](#specification)
  - [API Endpoints](#api-endpoints)
    - [Drivers](#drivers)
    - [Rides](#rides)
    - [Trips](#trips)
  - [Database](#database)
    - [Models](#models)
      - [Driver](#driver)
      - [Ride](#ride)
      - [Trip](#trip)
    - [Migrations](#migrations)
    - [Seed Data](#seed-data)
    - [Project Definitions](#project-definitions)

## Project Overview

Key features include:

- **Drivers**: Management of drivers with home addresses.
- **Rides**: Creation and management of rides with pickup and destination addresses (Google Maps API for distance and duration calculations).
- **Trips**: Association between drivers and rides, storing commute and trip details.

## Specification

 - [x] Create a Rails 7 application, using Ruby 3+

 - [x] Include the following entities:

   - [x] Ride
     - [x] Has an id, a start address and a destination address. You may end up adding additional information
   - [x] Driver
     - [x] Has an id and a home address

 - [x] Build a RESTful API endpoint that returns a paginated JSON list of rides in descending score order for a given driver

 - [x] Please write up API documentation for this endpoint in MarkDown or alternative

 - [x] Calculate the score of a ride in $ per hour as: (**ride earnings**) / (**commute duration** + **ride duration**). Higher is better

 - [x] Google Maps is expensive. Consider how you can reduce duplicate API calls

 - [x] Include RSpec tests

## API Endpoints
I've included a Postman file for convenience.

### Drivers

- **List all drivers**: `GET /user_drivers`
- **Create a new driver**: `POST /user_drivers`

### Rides

- **List all rides**: `GET /rides`
- **Create a new ride**: `POST /rides`
- **Show details of a ride**: `GET /rides/:id`
- **Update a ride**: `PUT /rides/:id`
- **Delete a ride**: `DELETE /rides/:id`

### Trips

- **List all trips**: `GET /trips`
- **Create a new trip**: `POST /trips`
- **Show details of a trip**: `GET /trips/:id`
- **Update a trip**: `PUT /trips/:id`
- **Delete a trip**: `DELETE /trips/:id`

## Database

### Models

#### Driver

The `Driver` model represents a driver in the system.

- **Attributes**:
  - `id`: Unique identifier (string)
  - `home_address`: Address of the driver's home (string)

- **Associations**:
  - `has_many :trips`

#### Ride

The `Ride` model represents a ride in the system.

- **Attributes**:
  - `id`: Unique identifier (string)
  - `pickup_address`: Address where the ride starts (string)
  - `destination_address`: Address where the ride ends (string)
  - `ride_minutes`: Duration of the ride in minutes (decimal)
  - `ride_miles`: Distance of the ride in miles (decimal)

- **Associations**:
  - `has_many :trips`

#### Trip

The `Trip` model represents a trip taken by a driver for a specific ride.

- **Attributes**:
  - `id`: Unique identifier (string)
  - `driver_id`: Foreign key referencing `Driver` (string)
  - `ride_id`: Foreign key referencing `Ride` (string)
  - `commute_minutes`: Duration of the driver's commute in minutes (decimal)
  - `commute_miles`: Distance of the driver's commute in miles (decimal)
  - `total_minutes`: Total duration of the trip in minutes (decimal)
  - `total_hours`: Total duration of the trip in hours (decimal)
  - `total_miles`: Total distance of the trip in miles (decimal)
  - `earnings`: Earnings for the trip (decimal)

- **Associations**:
  - `belongs_to :driver`
  - `belongs_to :ride`

### Migrations

The database schema is managed using ActiveRecord migrations. Each model has its own migration file to define its table structure and constraints.

- `db/migrate/YYYYMMDDHHMMSS_create_user_drivers.rb`: Defines the `drivers` table.
- `db/migrate/YYYYMMDDHHMMSS_create_rides.rb`: Defines the `rides` table.
- `db/migrate/YYYYMMDDHHMMSS_create_trips.rb`: Defines the `trips` table.

### Seed Data

The seed data initializes the database with sample records for drivers and rides. It calculates dynamic values such as ride distances and durations using the Google Maps API.

- `db/seeds.rb`: Seeds the database with sample `Driver` and `Ride` records.



### Project Definitions
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

**Personal Note:**
*I spent (probably) too much time in version conflicts. In the end, I decided to just make a Docker'ed project and bypass the issue. There's nothing in the assignment about containerizing, so I hope this direction is acceptable.*
