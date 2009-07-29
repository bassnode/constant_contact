
module ConstantContact
  class Base < ActiveResource::Base
    self.site = "https://api.constantcontact.com"
    self.format = :atom
    class << self
      
      
      def api_key
        if defined?(@api_key)
          @api_key
        elsif superclass != Object && superclass.api_key
          superclass.api_key.dup.freeze
        end
      end

      def api_key=(api_key)
        @connection = nil
        @api_key = api_key
      end
      
      def connection(refresh = false)
        if defined?(@connection) || superclass == Object
          @connection = ActiveResource::Connection.new(site, format) if refresh || @connection.nil?
          @connection.user = "#{api_key}%#{user}" if user
          @connection.password = password if password
          @connection.timeout = timeout if timeout
          @connection
        else
          superclass.connection
        end
      end
      
      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "/ws/customers/#{self.user}#{prefix(prefix_options)}#{collection_name}"
      end  
      
      def element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{collection_path}/#{id}"
      end      
    end
    
    def encode
      "<entry xmlns=\"http://www.w3.org/2005/Atom\">
        <title type=\"text\"> </title>
        <updated>2008-07-23T14:21:06.407Z</updated>
        <author>Bluesteel</author>
        <id>data:,none</id>
        <summary type=\"text\">Bluesteel</summary>
        <content type=\"application/vnd.ctct+xml\">
        #{self.to_xml}
        </content>
      </entry>"      
    end
    
    
  end
end