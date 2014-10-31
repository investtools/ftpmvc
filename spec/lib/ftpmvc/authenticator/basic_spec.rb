require './spec/spec_helper'

require 'ftpmvc/authenticator/basic'

describe FTPMVC::Authenticator::Basic do
  describe '#authenticate' do
    let(:authenticator) do
      FTPMVC::Authenticator::Basic.new users: {
        'fabio' => 'iS2grails'
      }
    end
    context 'when username and password are listed on users map' do
      it 'returns true' do
        expect(authenticator.authenticate('fabio', 'iS2grails')).to be true
      end
    end
    context 'when username is not listed on users map' do
      it 'returns false' do
        expect(authenticator.authenticate('lucas', 'iS2grails')).to be false
      end
    end
    context 'when username is listed on users map but password is incorrect' do
      it 'returns false' do
        expect(authenticator.authenticate('fabio', 'wrongpassword')).to be false
      end
    end
  end
end
