module ActiveResource
  module Formats
    module HtmlEncodedFormat
      extend self
      def mime_type
        "application/x-www-form-urlencoded"
      end
      
      
      def decode(xml)
        {}
      end
      

    end
  end
end