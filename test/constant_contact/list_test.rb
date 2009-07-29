require File.dirname(__FILE__) + '/../test_helper'

class ListTest < Test::Unit::TestCase

  context 'members' do
    
  end
#   context 'initialize' do
#       setup do
#         @xml_str_1 = <<Feed
#           <ContactList xmlns="http://ws.constantcontact.com/ns/1.0/" id="http://api.constantcontact.com/ws/customers/recordkick/lists/1">
#             <OptInDefault>true</OptInDefault>
#             <Name>General Interest</Name>
#             <ShortName>General Interest</ShortName>
#             <DisplayOnSignup>Yes</DisplayOnSignup>
#             <SortOrder>1</SortOrder>
#             <Members id="http://api.constantcontact.com/ws/customers/recordkick/lists/1/members"></Members>
#           </ContactList>
# Feed
#           
#         @xml_str_2  = <<Feed
#           <ContactList xmlns="http://ws.constantcontact.com/ns/1.0/" id="http://api.constantcontact.com/ws/customers/recordkick/lists/active">
#             <Name>Active</Name>
#             <ShortName>Active</ShortName>
#           </ContactList
# Feed
#       end
#     
#     should 'parse and assign attributes' do
#       l = ConstantContact::List.new(@xml_str_1)
#       assert l.opt_in_default
#       assert_equal 'General Interest', l.name
#       assert_equal 'General Interest', l.short_name
#       assert_equal 'Yes', l.display_on_signup
#       assert_equal '1', l.sort_order
#       assert_equal '/ws/customers/recordkick/lists/1/members', l.member_url
#     end
#     
#     should 'parse and assign attributes in cases where attributes are missing' do
#       l = ConstantContact::List.new(@xml_str_2)
#       assert_equal 'Active', l.name
#       assert_equal 'Active', l.short_name
#       
#     end
#   end
#   
#   context 'members' do
#     setup do
#       @constant_contact = ConstantContact::Base.new('api_key', 'joesflowers', 'password')
#               @xml_str_1 = <<Feed
#                 <ContactList xmlns="http://ws.constantcontact.com/ns/1.0/" id="http://api.constantcontact.com/ws/customers/recordkick/lists/1">
#                   <OptInDefault>true</OptInDefault>
#                   <Name>General Interest</Name>
#                   <ShortName>General Interest</ShortName>
#                   <DisplayOnSignup>Yes</DisplayOnSignup>
#                   <SortOrder>1</SortOrder>
#                   <Members id="http://api.constantcontact.com/ws/customers/recordkick/lists/1/members"></Members>
#                 </ContactList>
# Feed
#     end
#   
#     should 'get 50 members' do
#       stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/recordkick/lists/1/members', 'memberscollection.xml')
#       l = ConstantContact::List.new(@xml_str_1)
#       assert_equal '/ws/customers/recordkick/lists/1/members', l.member_url
#       m = l.members
#       m.size.should == 50
#     end
#   end
  
end