require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'mocha'
require 'fakeweb'

FakeWeb.allow_net_connect = false

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'constant_contact'

class Test::Unit::TestCase
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def constant_contact_url(url)
  url =~ /^http/ ? url : "http://api.constantcontact.com#{url}"
end

def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, constant_contact_url(url), options)
end

def stub_post(url, filename)
  FakeWeb.register_uri(:post, constant_contact_url(url), :body => fixture_file(filename))
end

def stub_put(url, filename)
  FakeWeb.register_uri(:put, constant_contact_url(url), :body => fixture_file(filename))
end

def stub_delete(url, status)
  options = {:status => status}
  FakeWeb.register_uri(:delete, constant_contact_url(url), options)
end
