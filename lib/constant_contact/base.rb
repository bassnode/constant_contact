module ConstantContact
  class Base < ActiveResource::Base
    
    self.site = "https://api.constantcontact.com"
    self.format = :atom

    DATE_FORMAT = "%Y-%m-%dT%H:%M:%SZ"

    class << self
      # Returns an integer which can be used in #find calls.
      # Assumes url structure with the id at the end, e.g.:
      #   http://api.constantcontact.com/ws/customers/yourname/contacts/29
      def parse_id(url)
        url.to_s.split(/\//).last.to_i
      end
    
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
        integer_id = parse_id(id)
        id_val = integer_id.zero? ? nil : "/#{integer_id}"
        "#{collection_path}#{id_val}#{query_string(query_options)}"
      end      
    end
    
    # Slightly tweaked ARes::Base's implementation so all the
    # attribute names are looked up using camelcase since
    # that's how the CC API returns them.
    def method_missing(method_symbol, *arguments) #:nodoc:
      method_name = method_symbol.to_s

      case method_name.last
        when "="
          attributes[method_name.first(-1).camelize] = arguments.first
        when "?"
          attributes[method_name.first(-1).camelize]
        else
          attributes.has_key?(method_name.camelize) ? attributes[method_name.camelize] : super
      end
    end        

    # Caching accessor for the the id integer
    def int_id
      @id ||= self.class.parse_id(self.attributes['id'])
    end
    
    # Mimics ActiveRecord's version
    def update_attributes(atts={})
      camelcased_hash = {}
      atts.each{|key, val| camelcased_hash[key.to_s.camelize] = val}
      self.attributes.update(camelcased_hash)
      save
    end
    
    # Mimic ActiveRecord (snagged from HyperactiveResource).
    def save
      return false unless valid?
      before_save    
      successful = super
      after_save if successful
      successful
    end 
    
    def before_save
    end
    
    def after_save
    end
    
    def validate      
    end

    # So client-side validations run
    def valid? 
      errors.clear
      validate 
      super 
    end
    
    def encode
      "<entry xmlns=\"http://www.w3.org/2005/Atom\">
        <title type=\"text\"> </title>
        <updated>#{Time.now.strftime(DATE_FORMAT)}</updated>
        <author>Bluesteel</author>
        <id>#{id.blank? ? 'data:,none' : id}</id>
        <summary type=\"text\">Bluesteel</summary>
        <content type=\"application/vnd.ctct+xml\">
        #{self.to_xml}
        </content>
      </entry>"      
    end
    
    # TODO: Move this out to a lib
    def html_encode(txt)
      mapping = { '&' => '&amp;', '>' => '&gt;', '<' => '&lt;', '"' => '&quot;' }
      txt.to_s.gsub(/[&"><]/) { |special| mapping[special] }
    end
  end
end