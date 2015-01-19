require './spec/spec_helper'

require 'ftpmvc/filter/filesystem_access'
require 'ftpmvc/file'

describe FTPMVC::Filter::FilesystemAccess do
  let(:filesystem) do
    FTPMVC::Directory.new('/') do
      directory :music
    end
  end
  let(:filter) { FTPMVC::Filter::FilesystemAccess.new(filesystem, nil) }
  before do
    stub_const 'MusicDirectory', Class.new(FTPMVC::Directory)
  end

  describe '#dir_contents' do
    it 'is an array' do
      expect(filter.index('/')).to be_kind_of Array
    end
  end

  describe '#directory?' do
    context 'when path exists' do
      it 'is true' do
        expect(filter.directory?('/music')).to be true
      end
    end
    context 'when path is not a directory' do
      before do
        allow_any_instance_of(MusicDirectory)
          .to receive(:index)
          .and_return [ FTPMVC::File.new('bob_marley.mp3') ]
      end
      it 'is false' do
        expect(filter.directory?('/music/bob_marley.mp3')).to be false
      end
    end
    context 'when path does not exist' do
      it 'is false' do
        expect(filter.directory?('/documents')).to be false
      end
    end
  end

  describe '#get' do
    before do
      allow_any_instance_of(MusicDirectory)
        .to receive(:index)
        .and_return [ FTPMVC::File.new('songs.txt') ]
      allow_any_instance_of(MusicDirectory)
        .to receive(:get).with('songs.txt')
        .and_return StringIO.new('Pink Floyd')
    end
    it 'is the return of the directory' do
      expect(filter.get('/music/songs.txt').read)
        .to eq 'Pink Floyd'
    end
  end

  describe '#put' do
    let(:stream) { double('stream') }
    it 'forwards to directory' do
      expect_any_instance_of(MusicDirectory)
        .to receive(:put)
        .with 'songs.txt', stream
      filter.put('/music/songs.txt', stream)
    end
  end
end