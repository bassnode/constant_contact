# Value limits: http://constantcontact.custhelp.com/cgi-bin/constantcontact.cfg/php/enduser/std_adp.php?p_faqid=2217
module ConstantContact
  class Contact < Base
    attr_accessor :opt_in_source

    # @@column_names = [ :addr1, :addr2, :addr3, :city, :company_name, :country_code, :country_name, 
    #                       :custom_field1, :custom_field10, :custom_field11, :custom_field12, :custom_field13, 
    #                       :custom_field14, :custom_field15, :custom_field2, :custom_field3, :custom_field4, :custom_field5, 
    #                       :custom_field6, :custom_field7, :custom_field8, :custom_field9, :email_address, :email_type, 
    #                       :first_name, :home_phone, :insert_time, :job_title, :last_name, :last_update_time, :name, :note, 
    #                       :postal_code, :state_code, :state_name, :status, :sub_postal_code, :work_phone ]
    
    def to_xml
      xml = Builder::XmlMarkup.new
      xml.tag!("Contact", :xmlns => "http://ws.constantcontact.com/ns/1.0/") do
      	self.attributes.each{|k, v| xml.tag!( k.to_s.camelize, v )}
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
    
    # Can we email them?
    def active?
      status.downcase == 'active'
    end
  end
end