require 'bundler'
Bundler.require

class User
end

class CustomSorter
end

# The API itself!
# namespace it if only because of good practices ;)
namespace '/api/v1' do
  
  before do
    content_type 'application/json'
  end

  get '/hello' do
    { test: "hello!" }.to_json
  end

end