require './spec/spec_helper'

require 'ftpmvc/application'
require 'ftpmvc/file'
require 'ftpmvc/authenticator/basic'
require 'ftpmvc/filter/base'

describe FTPMVC::Application do
  describe '#filter' do
    before do
      stub_const 'FTPMVC::Filter::Foo', Class.new(FTPMVC::Filter::Base)
      allow_any_instance_of(FTPMVC::Filter::Foo)
        .to receive(:index)
        .and_return [ foo_file ]
    end
    let(:foo_file) { FTPMVC::File.new('foo') }
    let(:application) do
      FTPMVC::Application.new do
        filter FTPMVC::Filter::Foo
        filesystem do
          directory name: 'music'
        end
      end
    end
    it 'applies filter on index' do
      expect(application.index('/')).to eq [ foo_file ]
    end
    context 'when filter chains' do
      let(:application) do
        FTPMVC::Application.new do
          filter FTPMVC::Filter::Base
          filesystem do
            directory name: 'music'
          end
        end
      end
      it 'works' do
        expect(application.index('/').first.name).to eq 'music'
      end
    end
    context 'when a symbol is given' do
      let(:application) do
        FTPMVC::Application.new do
          filter :foo
        end
      end
      it 'initializes a class on FTPMVC::Filter with given options' do
        expect(application.index('/')).to eq [ foo_file ]
      end
    end
    context 'when a class is given' do
      let(:application) do
        FTPMVC::Application.new do
          filter FTPMVC::Filter::Foo
        end
      end
      it 'initializes that class with given options' do
        expect(application.index('/')).to eq [ foo_file ]
      end
    end
  end

  describe '#authenticator' do
    context 'when an instance is given' do
      let(:application) do
        FTPMVC::Application.new do
          authenticator FTPMVC::Authenticator::Basic.new users: {}
        end
      end
      it 'sets auth as that' do
        expect(application.auth).to be_a_kind_of(FTPMVC::Authenticator::Basic)
      end
    end
    context 'when a symbol is given' do
      let(:application) do
        FTPMVC::Application.new do
          authenticator :basic, users: { 'a' => 'b' }
        end
      end
      it 'initializes a class on FTPMVC::Authenticator with given options' do
        expect(application.auth).to eq FTPMVC::Authenticator::Basic.new users: { 'a' => 'b' }
      end
    end
    context 'when a class is given' do
      let(:application) do
        FTPMVC::Application.new do
          authenticator FTPMVC::Authenticator::Basic, users: { 'a' => 'b' }
        end
      end
      it 'initializes that class with given options' do
        expect(application.auth).to eq FTPMVC::Authenticator::Basic.new users: { 'a' => 'b' }
      end
    end
  end

  describe '#authenticate' do
    let(:custom_authenticator) { double('custom_authenticator') }
    let(:application) do
      auth = custom_authenticator
      FTPMVC::Application.new do
        authenticator auth
      end
    end
    it 'forwards to authenticator' do
      expect(custom_authenticator)
        .to receive(:authenticate)
        .with('fabio', 'iS2grails')
      application.authenticate('fabio', 'iS2grails')
    end
  end
  context 'when no authenticator is defined' do
    let(:application) { FTPMVC::Application.new }
    it 'returns always true' do
      expect(application.authenticate('fabio', 'iS2grails')).to be true
    end
  end

  describe '#handle_exception' do
    let(:exception) { Exception.new }
    let(:application) do
      handler = lambda { |e| @exception_handler_executed = true }
      FTPMVC::Application.new do
        on_exception(&handler)
      end
    end
    before do
      exception.set_backtrace([])
    end
    it 'calls exception handler' do
      application.handle_exception(exception)
      expect(@exception_handler_executed).to be true
    end
    context 'when exception handler is not defined' do
      let(:application) do
        FTPMVC::Application.new
      end
      it 'does not call nil' do
        expect { application.handle_exception(exception) }.to_not raise_error
      end
    end
  end
end