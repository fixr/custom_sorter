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

  # implement sorting through params
  # example: /api/v1/asc/name/oss/age
  get '/sort/:order/?:field1?/?:field2?/?:field3?' do
  end

  # for sake of simplicity (and not using persistence!), let's
  # assume the patch also implements sorting
  patch '/sort/:order/?:field1?/?:field2?/?:field3?' do
  end

end