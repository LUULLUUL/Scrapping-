require 'nokogiri'
require 'open-uri'

def get_deputy_infos(deputy_urls)

  # Scrapping the deputy list 
  deputy_fullname = deputy_urls.map { |page| Nokogiri::HTML(open(page)).xpath('//h1').text }
  deputy_firstname = deputy_fullname.map { |fullname| fullname.split[0] }

  deputy_lastname = deputy_fullname.map { |fullname| fullname.split[1..-1] }
  
  deputy_email = deputy_urls.map { |page| Nokogiri::HTML(open(page)).xpath('//a[contains(text(),"@assemblee-nationale.fr")]').text }
  
  # We arrange the arrays with each info
  deputy_firstname.map! { |fnames| ["first_name", fnames] }
  deputy_lastname.map! { |lnames| ["last_name", lnames] }
  deputy_email.map! { |em | ["email", em] }

  # And put them together into a hash
  result = deputy_firstname.zip(deputy_lastname, deputy_email)
  result.map! { |el| Hash[el] }.to_a
  puts result.inspect
end


def get_deputy_urls
  page = Nokogiri::HTML(open("https://www.nosdeputes.fr/deputes"))
  # deputys_scrap = page.xpath('//div[contains(concat(" ", @class, " "), " list_dep ")]')
  deputys_scrap = page.xpath('//td//a/@href')
  deputy_urls = deputys_scrap.map {|link| "https://www.nosdeputes.fr#{link}" }
  return deputy_urls
end

get_deputy_infos(get_deputy_urls)
