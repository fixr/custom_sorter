### Ruby Custom Sorter

A sample (and simple!) demo Sinatra app that implements a custom sorting class.

## Sample usage:

```
cs = CustomSorter.new('desc')
cs.sort(Collection, :name, :age)
```

## Testing it out

# GET with sample data
curl -i -H "Content-Type: application/json" https://blooming-anchorage-70739.herokuapp.com/api/v1/sort/asc/name
curl -i -H "Content-Type: application/json" https://blooming-anchorage-70739.herokuapp.com/api/v1/sort/desc/age/name/oss_projects

Up to three params can be added to the URL, along with the direction.

# PUT with custom data
curl -i -X PUT -H "Content-Type: application/json" -d'[{"name":"DHH","age":40,"oss_projects":5}, {"name":"Linus","age":45,"oss_projects":1}]' https://blooming-anchorage-70739.herokuapp.com/api/v1/sort/desc