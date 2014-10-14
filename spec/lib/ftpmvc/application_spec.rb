require 'ftpmvc/application'
require 'ftpmvc/file'

describe FTPMVC::Application do
  describe '#filter' do
    before do
      stub_const 'FooFilter', Class.new(FTPMVC::Filter)
      allow_any_instance_of(FooFilter)
        .to receive(:index)
        .and_return [ foo_file ]
    end
    let(:foo_file) { FTPMVC::File.new('foo') }
    let(:application) do
      FTPMVC::Application.new do
        filter FooFilter
        filesystem do
          directory :music
        end
      end
    end
    it 'applies filter on index' do
      expect(application.index('/')).to eq [ foo_file ]
    end
    context 'when filter chains' do
      let(:application) do
        FTPMVC::Application.new do
          filter FTPMVC::Filter
          filesystem do
            directory :music
          end
        end
      end
      it 'works' do
        expect(application.index('/').first.name).to eq 'music'
      end
    end
  end
end