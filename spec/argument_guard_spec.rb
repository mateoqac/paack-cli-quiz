require './lib/argument_guard'

describe ArgumentGuard do
  subject { ArgumentGuard.missing_argument?(param) }

  describe '.missing_argument?' do
    context 'when city argument is missing' do
      let(:param) { nil }

      it 'returns true and output a message ' do
        expect do
           ArgumentGuard.missing_argument?(param)
        end.to output("Please write a city name (between quotes) after the command name\n").to_stdout_from_any_process
        expect(subject).to eq(true)
      end
    end

    context 'when argument is present' do
      let(:param) { 'city'}
      it 'return false' do
        expect(subject).to eq(false)
      end
    end
  end
end
