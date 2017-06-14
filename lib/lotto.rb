require 'restclient'
require 'nokogiri'

module  Lotto

  def fetch_mega_millions draws
    fetch_lotto "http://www.calottery.com/play/draw-games/mega-millions/winning-numbers/?page=1", draws
  end

  def fetch_power_millions draws
    fetch_lotto "http://www.calottery.com/play/draw-games/powerball/winning-numbers/?page=1", draws
  end

  def fetch_super_millions draws
    fetch_lotto "http://www.calottery.com/play/draw-games/superlotto-plus/winning-numbers/?page=1", draws
  end

  def get_draws_from_page link
    page = Nokogiri::HTML(RestClient.get(link))
    draws = []

    data = page.css("tr").map {|x| x.css("td")  };
    data = data.select {|x| !x.empty?}

    data.each do |row|
      date, draw = row[0].css("span").text.split(" - ")
      numbers = row[1].css("span").to_a
        .reduce([]){|s, num| s << num.text  }
        .reject {|x| x.empty?}
        .map{|x| x.to_i}
      mega = row[2].text.to_i

      draws << {
        draw: draw,
        date: date,
        numbers: numbers,
        mega: mega
      }
    end

    return draws
  end

  def fetch_lotto link, draws_number_requested
    results = get_draws_from_page(link)
    draws_found = results
    while draws_found.size < draws_number_requested && !results.empty?
      link, page = link.split('=')
      page = page.to_i + 1
      link = [link, page].join('=')
      results = get_draws_from_page(link)
      draws_found += results
    end

    return draws_found.slice(0, draws_number_requested)
  end

  def find_matches(draw_results, ticket)
    matches_found = []
    draw_results.each do |value|
      numbers_to_check = value[:numbers] + [value[:mega]]
      common = ( numbers_to_check & ticket)
      if !common.empty?
        matches_found << {
          draw_number: value[:draw],
          date: value[:date],
          matching_numbers: common
        }
      end
    end
    return matches_found
  end

end
