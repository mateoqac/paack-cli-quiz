require './lib/api_service'
require './lib/custom_errors/city_not_found_error'
require 'spec_helper'

describe ApiService do

  describe '.get_url_for' do
    context 'when the city exist and has an url' do
      let(:city) { 'Abrera' }
      body = '<?xml version="1.0" encoding="UTF-8" ?><report><location city="Listado de localidades - Provincia de Barcelona" num="627" level="3" level_name="Localidad"><data><name id="1182">Abrera</name><url>http://api.tiempo.com/index.php?api_lang=es&amp;localidad=1182</url></data></location></report>'
      before do
        stub_request(:get, "http://api.tiempo.com/index.php?api_lang=es&division=102&affiliate_id=#{ENV['AFFILIATE_ID']}")
          .to_return(:body => body, :status => 200, :headers => {})
      end
      it 'returns the url' do
        expect(ApiService.get_url_for(city)).to eq('http://api.tiempo.com/index.php?api_lang=es&localidad=1182')
      end
    end

    context 'when the city does not exist or has not an url' do
      let(:city) { 'Nothing' }
      body = '<?xml version="1.0" encoding="UTF-8" ?><report><location city="Listado de localidades - Provincia de Barcelona" num="627" level="3" level_name="Localidad"><data><name id="1182">Abrera</name><url>http://api.tiempo.com/index.php?api_lang=es&amp;localidad=1182</url></data></location></report>'
      before do
        stub_request(:get, "http://api.tiempo.com/index.php?api_lang=es&division=102&affiliate_id=#{ENV['AFFILIATE_ID']}")
          .to_return(:body => body, :status => 200, :headers => {})
      end

      it 'raises an error' do
        expect{ ApiService.get_url_for(city) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.today' do
    context 'when the city exist and has a valid url' do
      let(:city) { 'Aiguafreda'}
      body = '{ "day": {"1": {"local_time": "04:38", "hour": [{"interval":"02:00", "temp":"19"}] }}}'

      before do
          stub_request(:get, "http://api.tiempo.com/index.php?affiliate_id=#{ENV['AFFILIATE_ID']}&amp%3Blocalidad=1182&api_lang=es&v=3.0").
            with(
              headers: {
             'Accept'=>'*/*',
             'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
             'Host'=>'api.tiempo.com',
             'User-Agent'=>'rest-client/2.1.0 (darwin19.4.0 x86_64) ruby/2.5.1p57'
              }).
            to_return(status: 200, body: body, headers: {})
      end
      it 'returns a valid value'do
        allow(ApiService).to receive(:get_url_for).and_return('http://api.tiempo.com/index.php?api_lang=es&amp;localidad=1182')
        expect(ApiService.today(city)).to eq("19")
      end
    end

    context 'when the city does not exist and has no url' do
      let(:city) { 'frula'}

      before do
        stub_request(:get, "http://api.tiempo.com/index.php?api_lang=es&division=102&affiliate_id=#{ENV['AFFILIATE_ID']}")
          .to_return(:body => '', :status => 200, :headers => {})
      end

      it 'catchs the error and exit'do
        expect(ApiService.today(city)).to eq("#{city} not found, check spelling please.")
      end
    end
  end

  describe '.average' do
    context 'when the city exist and has a valid url' do
      let(:city) { 'Aiguafreda'}
      body_1 = '<?xml version="1.0" encoding="UTF-8" ?>
              <report>
                  <location>
                      <var><name>Temperatura Mínima</name><data><forecast data_sequence="1" value="15"/><forecast data_sequence="2" value="14"/><forecast data_sequence="3" value="15"/><forecast data_sequence="4" value="14"/><forecast data_sequence="5" value="15"/><forecast data_sequence="6" value="14"/><forecast data_sequence="7" value="15"/></data></var>
                  </location>
              </report>'

      before do
          stub_request(:get, "http://api.tiempo.com/index.php?affiliate_id=#{ENV['AFFILIATE_ID']}&amp%3Blocalidad=1182&api_lang=es").
            with(
              headers: {
             'Accept'=>'*/*',
             'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
             'Host'=>'api.tiempo.com',
             'User-Agent'=>'rest-client/2.1.0 (darwin19.4.0 x86_64) ruby/2.5.1p57'
              }).
            to_return(status: 200, body: body_1, headers: {})
      end

      it 'returns a valid value'do
        allow(ApiService).to receive(:get_url_for).and_return('http://api.tiempo.com/index.php?api_lang=es&amp;localidad=1182')
        expect(ApiService.average(city,'Temperatura Mínima')).to eq(14)
      end
    end

    context 'when the city does not exist and has no url' do
      let(:city) { 'frula'}

      before do
        stub_request(:get, "http://api.tiempo.com/index.php?api_lang=es&division=102&affiliate_id=#{ENV['AFFILIATE_ID']}")
          .to_return(:body => '', :status => 200, :headers => {})
      end

      it 'catchs the error and exit'do
        expect(ApiService.average(city,'Temperatura Máxima')).to eq("#{city} not found, check spelling please.")
      end
    end
  end
end
