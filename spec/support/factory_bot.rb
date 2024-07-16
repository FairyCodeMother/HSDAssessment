# spec/support/factory_bot.rb
# GINASAURUS: docker-compose run web rspec

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
