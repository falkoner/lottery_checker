require 'restclient'
require 'nokogiri'

module  Lotto

  def fetch_mega_millions
    fetch_lotto "http://www.calottery.com/play/draw-games/mega-millions/winning-numbers"
  end

  def fetch_power_millions
    fetch_lotto "http://www.calottery.com/play/draw-games/powerball/winning-numbers"
  end

  def fetch_super_millions
    fetch_lotto "http://www.calottery.com/play/draw-games/superlotto-plus/winning-numbers"
  end

  def fetch_lotto link
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

    return draws
  end

  def find_matches(draw_results, ticket)
    matches_found = []
    draw_results.each do |draw_number, value|
      numbers_to_check = value[:numbers] + [value[:mega]]
      common = ( numbers_to_check & ticket)
      if !common.empty?
        matches_found << {
          draw_number: draw_number,
          date: value[:date],
          matching_numbers: common
        }
      end
    end
    return matches_found
  end


end
