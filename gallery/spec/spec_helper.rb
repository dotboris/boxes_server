require 'boxes/test/env'
require 'boxes/test/mongodb'
require 'boxes/mongodb'

RSpec.configure do |c|
  c.include Boxes::Test::Env
  c.include Boxes::Test::MongoDb

  c.before :example, :real_mongo do
    inject_test_env!
    Boxes.configure_mongo_mapper
    clear_drawings_collection!
  end
end