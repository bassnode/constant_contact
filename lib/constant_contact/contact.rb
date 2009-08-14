module ConstantContact
  class Contact < Base
    attr_accessor :opt_in_source

    def to_xml
      xml = Builder::XmlMarkup.new
      xml.tag!("Contact", :xmlns => "http://ws.constantcontact.com/ns/1.0/") do
      	self.attributes.each{|k, v| xml.tag!(k.camelize, v)}
      	xml.tag!("OptInSource", self.opt_in_source)
      	xml.tag!("ContactLists") do 
      	  xml.tag!("ContactList", :id=> self.list_url)
      	end
      end        
    end
    
    def opt_in_source
      @opt_in_source ||= "ACTION_BY_CUSTOMER"
    end
    
    def list_url
      id = defined?(self.list_id) ? self.list_id : 1
      "http://api.constantcontact.com/ws/customers/#{self.class.user}/lists/#{id}"
    end
  
    
  end
end