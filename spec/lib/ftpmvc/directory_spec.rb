require './spec/spec_helper'

require 'ftpmvc/directory'
require 'ftpmvc/file'

describe FTPMVC::Directory do
  before do
    stub_const 'DocumentsDirectory', Class.new(FTPMVC::Directory)
  end
  let(:documents) { DocumentsDirectory.new('documents') }
  describe '.build' do
    context 'when there is a specific directory class' do
      it 'is an instance this specific class' do
        expect(FTPMVC::Directory.build(:documents)).to be_a DocumentsDirectory
      end
      it 'is an instance of DirectoryHandler' do
        expect(FTPMVC::Directory.build(:music)).to be_a FTPMVC::Directory
      end
    end
  end
  
  describe '#resolve' do
    before do
      stub_const 'ConfidentialDirectory', Class.new(FTPMVC::Directory)
      allow(documents)
        .to receive(:index)
        .and_return [ FTPMVC::File.new('contract.doc'), ConfidentialDirectory.new('confidential') ]
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
    it 'converts name to string' do
      expect(FTPMVC::Directory.new(:pictures).name).to eq 'pictures'
    end
    it 'yields with instance_eval' do
      my_class = nil
      FTPMVC::Directory.new('pictures') { my_class = self.class }
      expect(my_class).to be FTPMVC::Directory
    end
  end

  describe '#directory' do
    it 'adds a Directory object to content' do
      pictures = FTPMVC::Directory.new('pictures') do
        directory :safari
      end
      expect(pictures.resolve('safari')).to be_a FTPMVC::Directory
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
