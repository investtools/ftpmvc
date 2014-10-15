require './spec/spec_helper'

require 'ftpmvc/access_filesystem_filter'
require 'ftpmvc/file'

describe FTPMVC::AccessFilesystemFilter do
  let(:filesystem) do
    FTPMVC::Directory.new('/') do
      directory :music
    end
  end
  let(:filter) { FTPMVC::AccessFilesystemFilter.new(filesystem, nil) }
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

  describe '#bytes' do
    before do
      allow_any_instance_of(MusicDirectory)
        .to receive(:get).with('songs.txt')
        .and_return StringIO.new('Pink Floyd')
      allow_any_instance_of(MusicDirectory)
        .to receive(:get).with('documents.txt')
        .and_return nil
    end
    it 'is the return of the directory' do
      expect(filter.size('/music/songs.txt'))
        .to eq 10
    end
  end
end