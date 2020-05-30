require './lib/api_service'
require './lib/custom_errors/city_not_found_error'
require 'spec_helper'

describe ApiService do
  describe '.today' do
    context 'when the city exist and has a valid url' do
      it 'returns a valid value'do

      end
    end

    context 'when the city does not exist and has no url' do
      let(:city) { 'frula'}

      before do
        response = '[{ "subject": "a todo for you" }]'
        stub_request(:any, /www.example.com/).to_return(:body => response, :status => 200, :headers => {})
      end

      it 'raise an error'do
        expect do
          ApiService.today(city)
        end.to raise_error(CityNotFoundError)
      end
    end
  end
end
