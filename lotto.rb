require 'optparse'
require_relative 'lib/colorize'
require_relative 'lib/lotto'

include Colorize
include Lotto

options = {}
ALLOWED_LOTTO = {
  'mega' => "Mega Millions",
  'power' => "Powerball",
  'super' => "SuperLotto Plus"
}

options[:lotto] = 'mega'
options[:draws] = 20
parsed_opts = OptionParser.new do |opts|
  opts.banner = "Usage: lotto.rb [options]"

  opts.on("-l", "--lotto TYPE", ALLOWED_LOTTO.keys,
          "Type of lotto. Default: [mega], Available: [#{ALLOWED_LOTTO.keys.join(', ')}]") do |l|
    options[:lotto] = l
  end

  opts.on("-n", "--numbers A,B,C", Array, "6 numbers you bet on") do |numbers|
    options[:numbers] = numbers.map(&:to_i)
  end

  opts.on("-d", "--draws NUMBER_OF_DRAWS", Integer,
          "Number of last draws to check, 20 default" ) do |n|
    options[:draws] = n.to_i
  end

  opts.on_tail("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

end
parsed_opts.parse!

if options[:numbers].nil? || options[:numbers].size != 6
  puts "Need 6 numbers you are betting on"
  puts parsed_opts
  exit
end

draws = []
draws = fetch_mega_millions(options[:draws]) if options[:lotto] == 'mega'
draws = fetch_power_millions(options[:draws]) if options[:lotto] == 'power'
draws = fetch_super_millions(options[:draws]) if options[:lotto] == 'super'

if draws.nil? || draws.empty?
  puts "Can't fetch draws"
  exit
end

puts "Last #{draws.size} draws:"
puts draws
puts

puts "Betting on #{ALLOWED_LOTTO[options[:lotto]]}: #{green(options[:numbers].join(' '))}"

winning_numbers = find_matches(draws, options[:numbers])

winning_numbers.each do |wn|
  puts "Winning draw #{yellow(wn[:draw_number])} on #{yellow(wn[:date])}:
        matching numbers: [#{red(wn[:matching_numbers].join(' '))}] mega: [#{red(wn[:matching_mega])}]"
end
