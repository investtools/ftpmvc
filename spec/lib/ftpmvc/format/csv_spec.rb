require './spec/spec_helper'

require 'ftpmvc/format/csv'
require 'ftpmvc/file'

describe FTPMVC::Formats::CSV do
  let(:csv_file_class) do
    Class.new(FTPMVC::File) do
      include FTPMVC::Formats::CSV
      def rows
        [['a', 'b', 'c'], ['d', 'e', 'f']]
      end
    end
  end
  let(:csv_file) { csv_file_class.new('test') }
  describe '#data' do
    it 'is a CSV string based on #rows' do
      expect(csv_file.data.read).to eq "a,b,c\nd,e,f\n"
    end
    context 'when #rows is not an array of arrays' do
      before do
        row = double('row')
        allow(row).to receive(:to_a).and_return(['q', 'w', 'e'])
        allow(csv_file).to receive(:rows).and_return([row])
      end
      it 'firstly converts that' do
      expect(csv_file.data.read).to eq "q,w,e\n"
      end
    end
    context 'when #headers is defined' do
      before do
        allow(csv_file).to receive(:header).and_return(['X', 'Y', 'Z'])
      end
      it 'uses it on first line' do
        expect(csv_file.data.read).to eq "X,Y,Z\na,b,c\nd,e,f\n"
      end
    end
    context 'when date_format is defined' do
      let(:csv_file_class) do
        Class.new(FTPMVC::File) do
          include FTPMVC::Formats::CSV
          date_format '%m/%d/%y'
          def rows
            [[Date.parse('2011-01-01')]]
          end
        end
      end
      it 'formats dates' do
        expect(csv_file.data.read).to eq "01/01/11\n"
      end
    end
  end

  describe '#name' do
    it 'appends .csv to original name' do
      expect(csv_file.name).to eq 'test.csv'
    end
  end
end
