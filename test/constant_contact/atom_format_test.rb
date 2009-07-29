require File.dirname(__FILE__) + '/../test_helper'

class AtomFormatter
  include ActiveResource::Formats::AtomFormat
end
class AtomFormatTest < Test::Unit::TestCase
  
  context 'decode' do
    should 'convert an xml collection into an array' do
      c = AtomFormatter.new
      assert_kind_of Array, c.decode(fixture_file('contactlistscollection.xml'))
    end
    
    should 'convert xml for a single record into a something' do
      c = AtomFormatter.new
      assert_kind_of Hash, c.decode(fixture_file('contactlistsindividuallist.xml'))      
    end
    
    should 'return empty error if no content' do
      c = AtomFormatter.new
      assert_kind_of Array, c.decode(fixture_file('nocontent.xml'))      
    end
    
  end
  
end


