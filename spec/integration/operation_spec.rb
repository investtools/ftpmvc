require './spec/spec_helper'
require 'ftpmvc/application'

describe 'Operation' do
  before do
    music_directory_class = Class.new(FTPMVC::Directory) do
      def size(path)
        69
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
    it 'checks if directory exists' do
      with_application(app) do |ftp|
        ftp.login
        expect(ftp.size('/music/pink_floyd.mp3')).to eq 69
      end
    end
  end
  describe 'GET' do
    it 'checks if directory exists' do
      with_application(app) do |ftp|
        ftp.login
        expect(get(ftp, '/music/pink_floyd.mp3')).to eq 'content'
      end
    end
  end
end
