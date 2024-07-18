# HopSkipChallenge

HopSkipChallenge develops a RESTful API endpoint for managing Rides and Trips within a ride service app, utilizing Ruby 3 on Rails 7, integrating with Google Maps API for route calculations, and Dockerizd.

## Table of Contents

- [HopSkipChallenge](#hopskipchallenge)
  - [Table of Contents](#table-of-contents)
  - [API Endpoint Documentation: Fetch Trips by Chauffeur ID](#api-endpoint-documentation-fetch-trips-by-chauffeur-id)
    - [Description](#description)
    - [Endpoint URL](#endpoint-url)
    - [Parameters](#parameters)
    - [Response](#response)
    - [Error Handling](#error-handling)
- [Rails Assessment](#rails-assessment)
  - [Project Overview](#project-overview)
    - [Acceptance Criteria](#acceptance-criteria)
    - [My Checklist](#my-checklist)
    - [Project Definitions](#project-definitions)
  - [API Endpoints](#api-endpoints)
    - [Chauffeurs](#chauffeurs)
    - [Rides](#rides)
    - [Trips](#trips)
  - [Database](#database)
    - [Models](#models)
      - [Chauffeurs](#chauffeurs-1)
      - [Ride](#ride)
      - [Trip](#trip)

<br>

## API Endpoint Documentation:<br> Fetch Trips by Chauffeur ID

### Description

This endpoint retrieves a list of Trips associated with a specific Chauffeur identified by their ID.

### Endpoint URL

- **Request**: `GET /chauffeurs/:id/trips`
- **Example**: `/chauffeurs/c123/trips?page=1&per_page=10`


### Parameters
- **id** (required, integer): The unique identifier of the Chauffeur for whom trips are being fetched.

### Response
The API returns a JSON array containing Trip objects. Each Trip object includes details such as Trip ID, Chauffeur ID, Ride ID, commute details, total details, Ride earnings, and score.

**Example response:** earnings, and score.

**Example response:**
```json
[
  {
      "id": "t13580140-ca2a-462c-a21d-057a504f4ff1",
      "chauffeur_id": "ca5324861-b102-403c-ba11-dd462230b11b",
      "ride_id": "r44ef863a-e7e7-45f7-a9f3-792445cf31d3",
      "commute_minutes": "18.0",
      "commute_miles": "10.3",
      "total_minutes": "38.0",
      "total_hours": "0.63",
      "total_miles": "24.3",
      "earnings": "29.0",
      "score": "1.19",
      "created_at": "2024-07-18T02:26:20.050Z",
      "updated_at": "2024-07-18T02:26:20.050Z"
  },
  {
      "id": "tfef6fb4f-23fc-4984-9609-5045da0c8295",
      "chauffeur_id": "ca5324861-b102-403c-ba11-dd462230b11b",
      "ride_id": "r8653e848-c453-49b7-ad83-e7a6d2afa6c1",
      "commute_minutes": "21.0",
      "commute_miles": "15.0",
      "total_minutes": "43.0",
      "total_hours": "0.72",
      "total_miles": "30.1",
      "earnings": "32.05",
      "score": "1.06",
      "created_at": "2024-07-18T02:26:19.715Z",
      "updated_at": "2024-07-18T02:26:19.715Z"
  }, ...
  // More trip objects...
]
```
### Error Handling
**404 Not Found**: If the Chauffeur with the specified ID does not exist.

**500 Internal Server Error**: If there is a server-side issue.

<br>

# Rails Assessment

## Project Overview

### Acceptance Criteria

 - [x] Project uses Ruby 3+ and Rails 7
 - Ride: `Ride`
   - [x] Has an id (`:id`)
   - [x] Has a start address (`:pickup_address`)
   - [x] Has a destination address (`:dropoff_address`)
 - Driver: `Chauffeur`
   - [x] Has an id (`:id`)
   - [x] Has a home address (`:home_address`)
 - API
   - [x] Endpoint accepts a driver and returns a list of Trips: `/chauffeurs/:id/trips?page=1&per_page=10`
   - [x] API is RESTful
   - [x] API returns a paginated JSON list for a given driver
   - [x] Returned list is in descending score order
   - [x] API documentation MarkDown 
 - [x] Calculate the `score` of a ride in $ per hour. Higher is better.
   - `score` = (ride earnings) / (commute duration + ride duration)
 - [x] Google Maps is expensive. Consider how you can reduce duplicate API calls
    - [x] Caching
    - [x] Batched calls (untested)
 - [x] Include RSpec tests
 - [ ] Packaging: Create a private github repo and share it with @jacobkg

<br>


### My Checklist

 - [x] All Methods/Actions have error handling.
 - [x] Controllers focus on handling requests.
 - [x] RESTful statuses
   - [x] Create = :created
   - [x] Update = :ok
 - [x] Has validations/verifications
   - [x] Models
   - [x] Controllers
   - [x] Services
 - [x] Clean up my comments/housekeeping


### Project Definitions

- A `Ride` has a unique id, a start address and a destination address. (We may end up adding additional information).
- A `Chauffeur` has a unique id and a home address.
- The `driving distance` between two addresses is the distance in miles that it would take to drive a reasonably efficient route between them. It is not the straight line distance. It can be calculated by using a routing service
- The `driving duration` between two addresses is the amount of time in hours it would take to drive the driving distance under realistic driving conditions. It can be calculated by using a routing service
- The `commute distance` for a ride is the driving distance from the driver’s home address to the start of the ride, in miles
- The `commute duration` for a ride is the amount of time it is expected to take to drive the commute distance, in hours.
- The `ride distance` for a ride is the driving distance from the start address of the ride to the destination address, in miles
- The `ride duration` for a ride is the amount of time it is expected to take to drive the ride distance, in hours
- The `ride earnings` is how much the driver earns by driving the ride. It takes into account both the amount of time the ride is expected to take and the distance.
  - For the purposes of this exercise, it is calculated as:
    - $12 + ($1.50 per mile beyond 5 miles) + ((`ride_duration`) * $0.70 per minute beyond 15 minutes)
      - *$12 + ($1.50 * (`ride_distance` - 5 miles)) + ($0.70 * (`ride_duration` - 15 minutes)*


Key features include:

- **Chauffeurs**: Management of Chauffeurs with home addresses.
- **Rides**: Creation and management of Rides with pickup and dropoff addresses (Google Maps API for distance and duration calculations).
- **Trips**: Association between Chauffeurs and Rides, storing commute and ride details.



## API Endpoints
I've included a Postman file for convenience for the most pertinent actions: `HopSkipChallenge.postman_collection.json`

### Chauffeurs
- Create Chauffeur: `POST /chauffeurs`
- Create all Trips for Chauffeurs: `GET /chauffeurs/:id/trips`
- Destroy Chauffeur by ID: `DELETE /chauffeurs/:id`
- Fetch all Chauffeurs: `GET /chauffeurs`
- Fetch Chauffeur by ID: `GET /chauffeurs/:id`
- Update Chauffeur by ID: `PATCH/PUT /chauffeurs/:id`

### Rides
- Create Ride: `POST /rides`
- Destroy Ride by ID: `DELETE /rides/:id`
- Fetch all Rides: `GET /rides`
- Fetch Ride by ID: `GET /rides/:id`
- Update Ride by ID: `PATCH/PUT /rides/:id`

### Trips
- Create Trip: `POST /trips`
- Destroy Trip by ID: `DELETE /trips/:id`
- Fetch all Trips: `GET /trips`

## Database

### Models

#### Chauffeurs

The `Chauffeurs` model represents a driver (chauffeur) in the system.

- **Attributes**:
  - `id`: Unique identifier (string, starts with "c")
  - `home_address`: Address of the driver's home (string)

- **Associations**:
  - `has_many :trips`

#### Ride

The `Ride` model represents a route in the system.

- **Attributes**:
  - `id`: Unique identifier (string, starts with "r")
  - `pickup_address`: Address where the ride starts (string)
  - `dropoff_address`: Address where the ride ends (string)
  - `ride_minutes`: Duration of the ride in minutes (decimal)
  - `ride_miles`: Distance of the ride in miles (decimal)
  - `ride_earnings`: Earnings value of the route in dollars (decimal)

- **Associations**:
  - `has_many :trips`

#### Trip

The `Trip` model represents a trip taken by a driver for a specific ride.

- **Attributes**:
  - `id`: Unique identifier (string, starts with "t")
  - `chauffeur_id`: Foreign key referencing `Chauffeur` (string)
  - `ride_id`: Foreign key referencing `Ride` (string)
  - `commute_minutes`: Duration of the driver's commute in minutes (decimal)
  - `commute_miles`: Distance of the driver's commute in miles (decimal)
  - `total_minutes`: Total duration of the trip in minutes (decimal)
  - `total_hours`: Total duration of the trip in hours (decimal)
  - `total_miles`: Total distance of the trip in miles (decimal)
  - `score`: Represents the value of the trip, higher is more desirable (decimal)

- **Associations**:
  - `belongs_to :chauffeur`
  - `belongs_to :ride`

<br>

------------

**Personal Note:**

*I spent (probably) too much time in version conflicts. In the end, I decided to just make a Docker'ed project and bypass the issue. There's nothing in the assignment about containerizing, so I hope this direction is acceptable.*
