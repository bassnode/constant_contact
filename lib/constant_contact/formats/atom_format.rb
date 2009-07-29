module ActiveResource
  module Formats
    module AtomFormat
      extend self

      def extension
        "atom"
      end

      def mime_type
        "application/atom+xml"
      end

      def encode(hash, options={})
        hash.to_xml(options)
      end

      def decode(xml)
        return [] if no_content?(xml)
        result = Hash.from_xml(from_atom_data(xml))
        is_collection?(xml) ? result['records'] : result.values.first
      end
      

      private
      
      def from_atom_data(xml)
        if is_collection?(xml)
          return content_from_collection(xml)
        else
          return content_from_single_record(xml)
        end
      end
      
      def no_content?(xml)
        doc = REXML::Document.new(xml)
        REXML::XPath.match(doc,'//content').size == 0
      end
      
      def is_collection?(xml)
        doc = REXML::Document.new(xml)
        REXML::XPath.match(doc,'//content').size > 1
      end

      def content_from_single_record(xml)
        doc = REXML::Document.new(xml)
        str = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        REXML::XPath.each(doc, '//content') do |e|
          content = e.children[1]
          str << content.to_s
        end
        str
      end
      
      def content_from_collection(xml)
        doc = REXML::Document.new(xml)
        str = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><records type=\"array\">"
        REXML::XPath.each(doc, '//content') do |e|
          content = e.children[1]
          str << content.to_s
        end
        str << "</records>" 
        str
      end
      
      def content_from_member(xml)
        doc = REXML::Document.new(xml)
        str = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        REXML::XPath.each(doc, '//content') do |e|
         content = e.children[1].children
         str << content.to_s
        end
        str
      end
    end
  end
end
