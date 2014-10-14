$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'date'
require 'ftpmvc'

class AccrualFile < FTPMVC::File
  def initialize(date)
    @date = date
    super("accruals-#{date.strftime('%Y%m%d')}.csv")
  end

  def data
    StringIO.new("Date: #{@date}")
  end
end

class AccrualsDirectory < FTPMVC::Directory
  def index
    (Date.today-30).upto(Date.today).map { |d| AccrualFile.new(d) }
  end
end

s = FTPMVC::Directory.new('/') do
  directory :outbox do
    directory :accruals
  end
end
FTPMVC::Server.new(2222).start(s)
