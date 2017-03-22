require 'bundler'
require 'set'
require 'yaml'

Bundler.require

module UserData
  def sample(populate = [])
    users = []
    data = populate.empty? ? load_sample : populate

    data.each do |u|
      users << User.new(u['name'], u['age'], u['oss_projects'])
    end
    users
  end

  def load_sample
    YAML.load_file('users.yaml')
  end

end

class User < Struct.new(:name, :age, :oss_projects)
  extend UserData
end


class CustomSorter

  SORT_OPTIONS = ['asc', 'desc']

  def initialize(order = 'asc', opts = {})
    raise "Invalid sorting order" unless sort_options.include?(order.downcase)
    
    @order = order.downcase
  end

  def sort(collection, *args)
    raise "Element is not sortable" unless collection.is_a?(Enumerable)

    sorted = Array.new
    sorted = collection.sort_by{ |s| args.collect{ |a| s.send(a) } }
    sorted.reverse! if desc?
    sorted
  end


  private

  def desc?
    @order == 'desc'
  end

  def sort_options
    # Using a Set is far better performer
    Set.new(SORT_OPTIONS.map(&:downcase))
  end

end


# The API itself!
# namespace it if only because of good practices ;)
namespace '/api/v1' do
  
  before do
    content_type 'application/json'
  end

  helpers do

    # extract f* optional values
    def sorting_params
      params.select { |k| k.to_s.match(/^f\d+/) }.values
    end

    # read body payload
    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message:'Invalid JSON' }.to_json
      end
    end

    # parse objects to json
    def obj_to_json(obj_collection)
      obj_collection.map { |o| o.to_h }.to_json
    end

  end

  # implement sorting through params
  # example: /api/v1/asc/name/oss/age
  #
  # Test: curl -i -H "Content-Type: application/json" https://blooming-anchorage-70739.herokuapp.com/api/v1/sort/asc/name
  get '/sort/:order/?:f1?/?:f2?/?:f3?' do
    cs = CustomSorter.new(params[:order])
    obj_to_json cs.sort(User.sample, *sorting_params)
  end

  # for sake of simplicity (and not using persistence!), let's
  # assume the patch also implements sorting
  #
  # Test: curl -i -X PATCH -H "Content-Type: application/json" -d'[{"name":"Freddy","age": 32,"oss_projects":3}, {"name":"Linus","age": 45,"oss_projects":1}]' https://blooming-anchorage-70739.herokuapp.com/api/v1/sort/desc
  patch '/sort/:order/?:f1?/?:f2?/?:f3?' do
    users = User.sample(json_params)
    cs = CustomSorter.new(params[:order])
    obj_to_json cs.sort(users, *sorting_params)
  end

end