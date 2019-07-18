require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))

def scraping(page)
  # Scraping abbreviation of the the cryptocurrency
  currencies_scrap = page.xpath('//td[contains(concat(" ",normalize-space(@class)," "), " col-symbol ")]')
  currencies = currencies_scrap.map { |currency| currency.text.strip }
  
  
  # Scraping the value of the cryptocurrency
  values_scrap = page.xpath('//a[contains(concat(" ",normalize-space(@class)," "), " price ")]')
  values = values_scrap.map { |value| value.text.delete("$").to_f }
  
  # Combine the crypto name and value in one hash
  h = Hash[currencies.zip(values)]
  
  # Segmentation du hash en plusieurs hashes au sein d'un array
  result = [h.each {|k,v| Hash[k => v] }]

  puts result.inspect
end

scraping(page)

# Reste les tests à faire