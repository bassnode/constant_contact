require 'constant_contact'

ConstantContact::Base.api_key = ENV['CONSTANT_CONTACT_API_KEY']
ConstantContact::Base.user = ENV['CONSTANT_CONTACT_USER']
ConstantContact::Base.password = ENV['CONSTANT_CONTACT_PASSWORD']

