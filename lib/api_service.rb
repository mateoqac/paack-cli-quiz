require 'rest-client'
require "json"
require 'rexml/document'
include REXML


module ApiService
  BASE_URL = 'http://api.tiempo.com/index.php?api_lang=es&division=102&'
  AFFILIATE_ID = 'zdo2c683olan'
  WITH_AFF_ID = "&affiliate_id=#{AFFILIATE_ID}"
  JSON_RESP = '&v=3.0'
  MIN = 'Temperatura Mínima'
  MAX = 'Temperatura Máxima'

  def self.today(city)
    begin
      url = self.extract_url(city)
    rescue ArgumentError => e
      puts e.message
      exit
    end
    url +=WITH_AFF_ID+JSON_RESP
    response = RestClient.get(url)
    parsed = JSON.parse(response.body)['day']['1']
    current_time = parsed['local_time']
    intervals =  parsed['hour']
    ret = 0
    intervals.each do |inter|
      inter['interval'] > current_time ? break : ret = inter['temp']
    end
    puts ret
  end

  def self.average(city,key)
    begin
      url = self.extract_url(city)
    rescue ArgumentError => e
      puts e.message
      exit
    end
    url +=WITH_AFF_ID
    response = RestClient.get(url)
    xmldoc = Document.new(response.body)
    data = XPath.first(xmldoc, "//report//location//var//name[contains(text(),'#{key}')]/following-sibling::data")
    puts data.to_a.map {|ea| ea.attributes['value'].to_i}.inject(0) {|ac, e| ac + e}/data.size
  end

  def self.av_min(city)
    self.average(city, MIN)
  end

  def self.av_max(city)
    self.average(city, MAX)
  end

  def self.get_average(arr)
    sum = 0
    arr.each do |ea|
      sum +=ea['value'].to_i
    end
    sum/arr.size
  end

  def self.extract_url(city)
    response = RestClient.get(BASE_URL+WITH_AFF_ID)
    xmldoc = Document.new(response.body)
    url = XPath.first(xmldoc, "//location//data//name[contains(text(),'#{city}')]/following-sibling::url")
    return url.text unless url.nil?
    raise ArgumentError.new("#{city} not found, check spelling please.")
  end
end
