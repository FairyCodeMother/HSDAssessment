# Use the official Ruby 3.3.0 image as the base image
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory
WORKDIR /HopSkipChallenge

# Copy the Gemfile and Gemfile.lock
COPY Gemfile /HopSkipChallenge/Gemfile
COPY Gemfile.lock /HopSkipChallenge/Gemfile.lock

# Install the gems
RUN gem install bundler
RUN bundle install

# Copy the rest of the application code
COPY . /HopSkipChallenge

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
