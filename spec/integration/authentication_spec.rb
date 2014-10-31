require './spec/spec_helper'

require 'ftpmvc'

describe 'Authentication' do
  let(:app) do
    FTPMVC::Application.new do
      authenticator :basic, users: { 'fabio' => 'iS2grails' }
    end
  end

  describe 'LOGIN' do
    context 'when user/password is valid' do
      it 'authenticates' do
        with_application(app) do |ftp|
          expect(ftp.login('fabio', 'iS2grails')).to be true
        end
      end
    end
    context 'when user/password is valid' do
      it 'does not authenticate' do
        with_application(app) do |ftp|
          expect { ftp.login('lucas', 'pwd') }.to raise_error Net::FTPPermError
        end
      end
    end
  end
end
