require './spec/spec_helper'

require 'ftpmvc'

describe 'Operation' do
  before do
    music_directory_class = Class.new(FTPMVC::Directory) do
      def index
        [ FTPMVC::File.new('pink_floyd.mp3') ]
      end

      def get(path)
        StringIO.new('content')
      end
    end
    stub_const 'MusicDirectory', music_directory_class
  end
  let(:app) do
    FTPMVC::Application.new do
      filesystem do
        directory :music
      end
    end
  end

  describe 'LIST' do
    it 'lists files and directories' do
      with_application(app) do |ftp|
        ftp.login
        expect(ftp.list('/')).to include(/music/)
      end
    end
  end
  describe 'CHDIR' do
    it 'checks if directory exists' do
      with_application(app) do |ftp|
        ftp.login
        expect { ftp.chdir('/videos') }.to raise_error(Net::FTPPermError)
      end
    end
  end
  describe 'SIZE' do
    it 'is the file size' do
      with_application(app) do |ftp|
        ftp.login
        expect(ftp.size('/music/pink_floyd.mp3')).to eq 7
      end
    end
  end
  describe 'GET' do
    it 'is the file content' do
      with_application(app) do |ftp|
        ftp.login
        expect(get(ftp, '/music/pink_floyd.mp3')).to eq 'content'
      end
    end
  end
  describe 'GET' do
    it 'is the file content' do
      with_application(app) do |ftp|
        ftp.login
        expect(get(ftp, '/music/pink_floyd.mp3')).to eq 'content'
      end
    end
  end
  describe 'MDTM' do
    it 'is the modification time of a file' do
      with_application(app) do |ftp|
        ftp.login
        expect(ftp.mdtm('/music/pink_floyd.mp3')).to be_a_kind_of String
      end
    end
  end
end
