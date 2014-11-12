require 'active_support/concern'
require 'csv'

module FTPMVC
  module Format
    module CSV
      extend ActiveSupport::Concern

      def initialize(filename)
        super "#{filename}.csv"
      end

      def data
        StringIO.new(csv)
      end

      protected

      def header
      end

      def csv
        ::CSV.generate do |csv|
          csv << header if header.present?
          rows.each { |row| csv << row.to_a.map { |f| format(f) } }
        end
      end

      def format(field)
        self.class.format(field)
      end
      
      module ClassMethods
        def date_format(format)
          @date_format = format
        end

        def format(field)
          case field.class.name
          when 'Date'
            format_date(field)
          else
            field
          end
        end

        protected

        def format_date(date)
          date.strftime(@date_format)
        end
      end
    end
  end
end
