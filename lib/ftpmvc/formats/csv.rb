require 'active_support/concern'
require 'csv'

module FTPMVC
  module Formats
    module CSV
      extend ActiveSupport::Concern
      @@date_format = nil

      def header
      end

      def name
        "#{super}.csv"
      end

      def data
        ::CSV.generate do |csv|
          csv << header if header.present?
          rows.each { |row| csv << row.to_a.map { |f| format(f) } }
        end
      end

      protected

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
