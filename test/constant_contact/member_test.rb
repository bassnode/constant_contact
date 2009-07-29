require File.dirname(__FILE__) + '/../test_helper'

class MemberTest < Test::Unit::TestCase

  context 'initialize' do
      setup do
          @xml_str_1 = <<Feed
          <ContactListMember xmlns="http://ws.constantcontact.com/ns/1.0/" id="http://api.constantcontact.com/ws/customers/recordkick/contacts/5">
                <EmailAddress>toney_hane@browngislason.name</EmailAddress>
                <Name>Swaniawski, Noemi</Name>
          </ContactListMember>
Feed
          
      end
    
    should 'parse and assign attributes' do
      m = ConstantContact::Member.new(@xml_str_1)
      assert_equal 'Swaniawski, Noemi', m.name
      assert_equal 'toney_hane@browngislason.name', m.email_address
    end
end

end