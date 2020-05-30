require './lib/response_parse'
require './lib/custom_errors/response_parse_error'

describe ResponseParse do
  describe '.today_response' do
    context 'when the response code is different that 200' do
      it 'raises an error' do
        resp = double()
        allow(resp).to receive(:code).and_return(404)

        expect { subject.today_response(resp) }.to raise_error(an_instance_of(ResponseParseError)
                                                  .and having_attributes(message: "The response cannot be parsed"))
      end
    end

    context 'when the response code is 200' do
      it 'parses the JSON and returns a valid temperature' do
        resp = double()
        body = '{ "day": {"1": {"local_time": "04:38", "hour": [{"interval":"02:00", "temp":"19"}] }}}'
        allow(resp).to receive(:code).and_return(200)
        allow(resp).to receive(:body).and_return(body)

        expect(subject.today_response(resp)).to eq("19")
      end
    end

  end
  describe '.average_response' do
    context 'when the response code is different that 200' do
      it 'raises an error' do
        resp = double()
        allow(resp).to receive(:code).and_return(404)

        expect { subject.average_response(resp,"Temperatura Mínima") }.to raise_error(an_instance_of(ResponseParseError)
                                                  .and having_attributes(message: "The response cannot be parsed"))
      end
    end

    context 'when the response code is 200' do
      it 'parses the XML and returns a valid temperature' do
        resp = double()
        body = '<?xml version="1.0" encoding="UTF-8" ?>
                <report>
                    <location>
                        <var><name>Temperatura Mínima</name><data><forecast data_sequence="1" value="15"/><forecast data_sequence="2" value="14"/><forecast data_sequence="3" value="15"/><forecast data_sequence="4" value="14"/><forecast data_sequence="5" value="15"/><forecast data_sequence="6" value="14"/><forecast data_sequence="7" value="15"/></data></var>
                    </location>
                </report>'
        allow(resp).to receive(:code).and_return(200)
        allow(resp).to receive(:body).and_return(body)

        expect(subject.average_response(resp,"Temperatura Mínima")).to eq(14)
      end
    end
  end
end
