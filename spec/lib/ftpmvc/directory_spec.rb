require './spec/spec_helper'

require 'ftpmvc/directory'
require 'ftpmvc/file'

describe FTPMVC::Directory do
  before do
    stub_const 'DocumentsDirectory', Class.new(FTPMVC::Directory)
  end
  let(:documents) { DocumentsDirectory.new(name: 'documents') }
  
  describe '#resolve' do
    before do
      stub_const 'ConfidentialDirectory', Class.new(FTPMVC::Directory)
      allow(documents)
        .to receive(:index)
        .and_return [ FTPMVC::File.new('contract.doc'), ConfidentialDirectory.new(name: 'confidential') ]
      allow_any_instance_of(ConfidentialDirectory)
        .to receive(:index)
        .and_return [ FTPMVC::File.new('passwords.txt') ]
    end
    it 'finds files' do
      expect(documents.resolve('contract.doc')).to eq FTPMVC::File.new('contract.doc')
    end
    it 'finds files inside child directories' do
      expect(documents.resolve('confidential/passwords.txt')).to eq FTPMVC::File.new('passwords.txt')
    end
    it 'accepts slash as the first character' do
      expect(documents.resolve('/contract.doc')).to eq FTPMVC::File.new('contract.doc')
    end
    context 'when path does not exist' do
      it 'is nil' do
        expect(documents.resolve('phones.txt')).to be_nil
      end
    end
    context 'when path is /' do
      it 'is self' do
        expect(documents.resolve('/')).to be documents
      end
    end
    context 'when directory does not exist' do
      it 'is nil' do
        expect(documents.resolve('phones/home.txt')).to be_nil
      end
    end
  end

  describe '#initialize' do
    it 'yields with instance_eval' do
      my_class = nil
      FTPMVC::Directory.new(name: 'pictures') { my_class = self.class }
      expect(my_class).to be FTPMVC::Directory
    end
  end

  describe '#directory' do
    it 'adds a Directory object to content' do
      pictures = FTPMVC::Directory.new(name: 'pictures') do
        directory FTPMVC::Directory, name: 'safari'
      end
      expect(pictures.resolve('safari')).to be_a FTPMVC::Directory
    end
    context 'when a symbol is given' do
      it 'creates an instance of the directory based on that symnol' do
        home = FTPMVC::Directory.new(name: 'home') do
          directory :documents, name: 'documents'
        end
        expect(home.resolve('documents')).to be_a DocumentsDirectory
      end
    end
    context 'when a class is given' do
      it 'creates an instance of the given class' do
        home = FTPMVC::Directory.new(name: 'home') do
          directory DocumentsDirectory, name: 'documents'
        end
        expect(home.resolve('documents')).to be_a DocumentsDirectory
      end
    end
    context 'when a symbol is given and name is not' do
      it 'sets the name based on that symbol' do
        home = FTPMVC::Directory.new(name: 'home') do
          directory :documents
        end
        expect(home.resolve('documents')).to be_a DocumentsDirectory
      end
    end
    context 'when no symbol or class is given' do
      it 'creates a FTPMVC::Directory' do
        pictures = FTPMVC::Directory.new(name: 'pictures') do
          directory name: 'safari'
        end
        expect(pictures.resolve('safari')).to be_a FTPMVC::Directory
      end
    end
    context 'when an instance of directory is given' do
      it 'uses that instance' do
        pictures = FTPMVC::Directory.new(name: 'pictures') do
          directory FTPMVC::Directory.new(name: 'safari')
        end
        expect(pictures.resolve('safari')).to be_a FTPMVC::Directory
      end
    end
  end

  describe '#get' do
    let(:password_txt) { FTPMVC::File.new('password.txt') }
    before do
      allow(documents)
        .to receive(:index)
        .and_return [ password_txt ]
      allow(password_txt)
        .to receive(:data)
        .and_return StringIO.new('12345678')
    end
    it 'calls File#data' do
      expect(documents.get('password.txt').read).to eq '12345678'
    end
    context 'when path does not exist' do
      it 'is nil' do
        expect(documents.get('users.txt')).to be_nil
      end
    end
  end
end
