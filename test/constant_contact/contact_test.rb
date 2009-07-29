require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  
  context 'class' do
    setup do 
      ConstantContact::Base.user = "jonsflowers"
      @contact = ConstantContact::Contact.new(:email_address => "jon@gmail.com",
                             :first_name => "jon",
                             :last_name => "smith")
    end
    
    should 'respond to encode' do
      assert_respond_to ConstantContact::Contact.new, :encode
    end
    
    should 'call to_xml' do
      @contact.expects(:to_xml)
      @contact.encode
    end
  end
  
  context 'to_xml' do
    setup do 
      ConstantContact::Base.user = "jonsflowers"
      @contact = ConstantContact::Contact.new(:email_address => "jon@gmail.com",
                             :first_name => "jon",
                             :last_name => "smith")
    end
        
    should 'have contact tag' do
      assert_match /<Contact xmlns=\"http:\/\/ws.constantcontact.com\/ns\/1.0\/\"/, @contact.to_xml
      assert_match /\<\/Contact\>/, @contact.to_xml
    end
    
    should 'have first_name' do
      assert_match /<FirstName>/, @contact.to_xml
    end
    
    should 'list selected by default' do
      assert_match /http:\/\/api.constantcontact.com\/ws\/customers\/jonsflowers\/lists\/1/, @contact.to_xml
    end
    
    should 'provide opt in select by default' do
      assert_match /ACTION_BY_CUSTOMER/, @contact.to_xml
    end
  end
end
