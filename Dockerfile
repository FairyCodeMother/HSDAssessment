FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory
WORKDIR /HopSkipChallenge

# Copy the Gemfile and Gemfile.lock
COPY Gemfile /HopSkipChallenge/Gemfile
COPY Gemfile.lock /HopSkipChallenge/Gemfile.lock

# Install bundler and gems
RUN gem install bundler
RUN bundle install

# Copy the rest of the application code
COPY . /HopSkipChallenge

# Set the necessary environment variables
ARG GOOGLE_MAPS_API_KEY
ENV GOOGLE_MAPS_API_KEY=${GOOGLE_MAPS_API_KEY}

# Expose port 3000 to the Docker host
EXPOSE 3000

# Set up test database
RUN RAILS_ENV=test bundle exec rails db:create db:migrate

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
