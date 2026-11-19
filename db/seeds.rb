# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'uri'
require 'net/http'

url = URI("https://api.themoviedb.org/3/genre/movie/list?language=en")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'
request["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZjVmMGEzYjdhZmQ3MTI5YzhjMWVkNTExMDcxNGY1YyIsIm5iZiI6MTc5NTA4ODg3My4xODksInN1YiI6IjZhZmVlMWU5NmY2MzVjMzlhYjM4MjNjZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PzxGQn28EgkstvIx6Yz533pq4iHjLqBXxuT8CI66af4'

response = http.request(request)
genres = JSON.parse(response.read_body)["genres"]

genres.each do |genre|
  List.find_or_create_by!(name: genre["name"])
end



url1 = URI("https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")

http = Net::HTTP.new(url1.host, url1.port)
http.use_ssl = true

request1 = Net::HTTP::Get.new(url1)
request1["accept"] = 'application/json'
request1["Authorization"] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZjVmMGEzYjdhZmQ3MTI5YzhjMWVkNTExMDcxNGY1YyIsIm5iZiI6MTc5NTA4ODg3My4xODksInN1YiI6IjZhZmVlMWU5NmY2MzVjMzlhYjM4MjNjZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PzxGQn28EgkstvIx6Yz533pq4iHjLqBXxuT8CI66af4'

response1 = http.request(request1)
movies = JSON.parse(response1.read_body)["results"]
puts movies[0]

movies.each do |movie|
  Movie.find_or_create_by!(title: movie["title"], overview: movie["overview"], poster_url: "https://image.tmdb.org/t/p/original" + movie["poster_path"], rating: movie["vote_average"])
end
