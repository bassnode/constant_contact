require File.dirname(__FILE__) + '/../test_helper'

class ListTest < Test::Unit::TestCase

  context "find by name" do
    setup do 
      ConstantContact::Base.user = "joesflowers"
      ConstantContact::Base.password = "password"
      ConstantContact::Base.api_key = "api_key"
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/lists', 'contactlistscollection.xml')      
     
    end
    
    should 'find list for given name' do
       assert_equal 'Clients', ConstantContact::List.find_by_name("Clients").name
    end
  end
end