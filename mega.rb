require 'pp'
require_relative 'lib/colorize'
require_relative 'lib/lotto'

include Colorize
include Lotto

b_numbers = [1, 2, 3, 4, 5, 6]

draws = fetch_mega_millions()

puts "Last 20 draws:"
pp draws
puts

puts "Betting on: #{green(b_numbers.join(' '))}"

winning_numbers = find_matches(draws, b_numbers)

winning_numbers.each do |wn|
  puts "Winning draw #{yellow(wn[:draw_number])} on #{yellow(wn[:date])}:
        matching #{red(wn[:matching_numbers].join(' '))}"
end
