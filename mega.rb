require 'restclient'
require 'nokogiri'
require "pp"

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

puts "All draws:"
pp draws
puts

# Colored Output
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end

puts "Betting on: #{green(b_numbers.join(' '))}"
draws.each do |draw_number, value|
  numbers_to_check = value[:numbers] + [value[:mega]]
  common = ( numbers_to_check & b_numbers)
  if !common.empty?
    puts "Winning draw #{yellow(draw_number)} on #{yellow(value[:date])}:
          matching #{red(common.join(' '))}"
  end
end
