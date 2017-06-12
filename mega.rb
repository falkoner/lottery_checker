require 'restclient'
require 'nokogiri'
require_relative 'lib/colorize'

include Colorize

link = "http://www.calottery.com/play/draw-games/mega-millions/Winning-Numbers/"

b_numbers = [1, 2, 3, 4, 5, 6]

page = Nokogiri::HTML(RestClient.get(link))
draws = {}

data = page.css("tr").map {|x| x.css("td")  };
data = data.select {|x| !x.empty?}

data.each do |row|
  date, draw = row[0].css("span").text.split(" - ")
  numbers = row[1].css("span").to_a
    .reduce([]){|s, num| s << num.text  }
    .reject {|x| x.empty?}
    .map{|x| x.to_i}
  mega = row[2].text.to_i

  draws[draw.to_i] = {
    date: date,
    numbers: numbers,
    mega: mega
  }
end

puts "Last 20 draws:"
pp draws
puts

puts "Betting on: #{green(b_numbers.join(' '))}"
draws.each do |draw_number, value|
  numbers_to_check = value[:numbers] + [value[:mega]]
  common = ( numbers_to_check & b_numbers)
  if !common.empty?
    puts "Winning draw #{yellow(draw_number)} on #{yellow(value[:date])}:
          matching #{red(common.join(' '))}"
  end
end
