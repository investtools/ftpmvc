require 'ftpmvc/driver'
require 'ftpmvc/file'

describe FTPMVC::Driver do
  let(:structure) do
    FTPMVC::Directory.new('/') do
      directory :music
    end
  end
  let(:driver) { FTPMVC::Driver.new(structure) }
  before do
    stub_const 'MusicDirectory', Class.new(FTPMVC::Directory)
  end

  describe '#dir_contents' do
    it 'yields' do
      expect { |b| driver.dir_contents('/', &b) }.to yield_control
    end
    it 'yields an array of DirectoryItem' do
      driver.dir_contents('/') do |directory_items|
        expect(directory_items.map(&:name)).to eq ['music']
      end
    end
  end

  describe '#change_dir' do
    context 'when path exists' do
      it 'yields true' do
        expect { |b| driver.change_dir('/music', &b) }.to yield_with_args true
      end
    end
    context 'when path is not a directory' do
      before do
        allow_any_instance_of(MusicDirectory)
          .to receive(:index)
          .and_return [ FTPMVC::File.new('bob_marley.mp3') ]
      end
      it 'yields false' do
        expect { |b| driver.change_dir('/music/bob_marley.mp3', &b) }.to yield_with_args false
      end
    end
    context 'when path does not exist' do
      it 'yields false' do
        expect { |b| driver.change_dir('/documents', &b) }.to yield_with_args false
      end
    end
  end

  describe '#get_file' do
    before do
      allow_any_instance_of(MusicDirectory)
        .to receive(:index)
        .and_return [ FTPMVC::File.new('songs.txt') ]
      allow_any_instance_of(MusicDirectory)
        .to receive(:get).with('songs.txt')
        .and_return StringIO.new('Pink Floyd')
    end
    it 'yields the return of the directory' do
      expect { |b| driver.get_file('/music/songs.txt', &b) }
        .to yield_with_args StringIO.new('Pink Floyd')
    end
  end

  describe '#bytes' do
    before do
      allow_any_instance_of(MusicDirectory)
        .to receive(:get).with('songs.txt')
        .and_return StringIO.new('Pink Floyd')
      allow_any_instance_of(MusicDirectory)
        .to receive(:get).with('documents.txt')
        .and_return nil
    end
    it 'yields the return of the directory' do
      expect { |b| driver.bytes('/music/songs.txt', &b) }
        .to yield_with_args 10
    end
  end
end