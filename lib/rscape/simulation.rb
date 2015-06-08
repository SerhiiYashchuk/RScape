require_relative 'population.rb'

sugarscape = RScape::Sugarscape.new(width: 10, height: 10)
populaiton = RScape::Population.new sugarscape

5.times do
  new_sugar = RScape::Sugar.new(capacity: 5, level: 0, growth: 1)
  
  sugarscape.add_sugar(new_sugar, rand(sugarscape.width),
                       rand(sugarscape.height))
end

5.times do |t|
  puts "[Iteration #{t}]"
  
  sugarscape.growback
  
  sugarscape.sugars.each do |sugar|
    puts "Source #{sugar.id} has #{sugar.level} points of sugar."
  end
  
  puts
end
