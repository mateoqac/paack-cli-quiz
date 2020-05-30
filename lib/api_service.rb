require 'rest-client'
require './lib/response_parse'

module ApiService

  BASE_URL = 'http://api.tiempo.com/index.php?api_lang=es&division=102&'
  WITH_AFF_ID = "&affiliate_id=#{ENV['AFFILIATE_ID']}"
  JSON_RESP = '&v=3.0'
  MIN = 'Temperatura Mínima'
  MAX = 'Temperatura Máxima'

  def self.today(city)
    raise CityNotFoundError.new(url.message) if url.error?

    url +=WITH_AFF_ID+JSON_RESP
    response = RestClient.get(url)
    ResponseParse.today_response(response)
  end

  def self.average(city,key)
    begin
      url = self.get_url_for(city)
    rescue ArgumentError => e
      puts e.message
      exit
    end
    url +=WITH_AFF_ID
    response = RestClient.get(url)
    ResponseParse.average_response(response, key)
  end

  def self.av_min(city)
    self.average(city, MIN)
  end

  def self.av_max(city)
    self.average(city, MAX)
  end

  def self.get_url_for(city)
    response = RestClient.get(BASE_URL+WITH_AFF_ID)
    xmldoc = Document.new(response.body)
    url = XPath.first(xmldoc, "//location//data//name[contains(text(),'#{city}')]/following-sibling::url")
    return url.text unless url.nil?
    raise ArgumentError.new("#{city} not found, check spelling please.")
  end
end
