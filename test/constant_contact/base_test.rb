require File.dirname(__FILE__) + '/../test_helper'
# require 'activeresource'
require "fixtures/list"
class BaseTest < Test::Unit::TestCase
  
  # def test_should_use_site_prefix_and_credentials
  #   assert_equal 'https://baz%25foo:bar@api.constantcontact.com', List.site.to_s    
  # end
  
  # def test_should_accept_setting_user
  #   List.user = 'david'
  #   assert_equal('david', List.user)
  #   assert_equal('david', List.connection.user)
  # end
  
  def test_should_accept_setting_api_key
    List.api_key = 'david'
    assert_equal('david', List.api_key)
  end
  
  
  def test_should_accept_setting_password
    List.password = 'test123'
    assert_equal('test123', List.password)
    assert_equal('test123', List.connection.password)
  end
    
  def test_credentials_from_site_are_decoded
    actor = Class.new(ConstantContact::Base)
    actor.site = 'http://my%40email.com:%31%32%33@cinema'
    assert_equal("my@email.com", actor.user)
    assert_equal("123", actor.password)
  end
  
  def test_collection_name
    assert_equal "lists", List.collection_name
  end
  
  def test_collection_path
    List.user = 'joesflowers'
    assert_equal '/ws/customers/joesflowers/lists', List.collection_path
  end
  
  def test_element_path
    List.user = 'joesflowers'
    assert_equal '/ws/customers/joesflowers/lists/1', List.element_path(1)
  end
  
  def test_should_use_site_prefix_and_credentials
     ConstantContact::Base.user = "joesflowers"
     ConstantContact::Base.password = "password"
     ConstantContact::Base.api_key = "api_key"
     assert_equal 'https://api.constantcontact.com', ConstantContact::List.site.to_s
     assert_equal 'https://api.constantcontact.com/lists/:list_id/', ConstantContact::Member.site.to_s
  end
  
  
  context 'find' do
    setup do
      ConstantContact::Base.user = "joesflowers"
      ConstantContact::Base.password = "password"
      ConstantContact::Base.api_key = "api_key"
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/lists', 'contactlistscollection.xml')      
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/lists/1', 'contactlistsindividuallist.xml')      
      stub_get('https://api_key%25joesflowers:password@api.constantcontact.com/ws/customers/joesflowers/lists/1/members', 'memberscollection.xml')      
    end
    
    should 'find one' do
      list = List.find(1)
      assert_equal "General Interest", list.name
    end
        
    should 'find all' do
      lists = List.find(:all)
      assert_equal 5, lists.size
      assert_equal 'Clients', lists.last.name
    end
    
    should 'allow nested finds' do
      members = ConstantContact::Member.find :all, :params => {:list_id => 1}
      assert_equal 50, members.size
    end
  end
  
end  


