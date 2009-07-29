module ActiveResource
  module Formats
    module HtmlEncodedFormat
      extend self
      def mime_type
        "application/atom+xml"
      end
    end
  end
end