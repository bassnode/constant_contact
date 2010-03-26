# http://developer.constantcontact.com/doc/manageCampaigns
module ConstantContact
  class Campaign < Base
    STATUS_CODES = ['SENT', 'SCHEDULED', 'DRAFT', 'RUNNING']
    # SENT  All campaigns that have been sent and not currently scheduled for resend
    # SCHEDULED   All campaigns that are currently scheduled to be sent some time in the future
    # DRAFT   All campaigns that have not yet been scheduled for delivery
    # RUNNING   All campaigns that are currently being processed and delivered
    @@column_names = [:archive_status, :archive_url, :bounces, :campaign_type, :clicks, :contact_lists, :date, 
                      :email_content, :email_content_format, :email_text_content, :forward_email_link_text, :forwards, 
                      :from_email, :from_name, :greeting_name, :greeting_salutation, :greeting_string, 
                      :include_forward_email, :include_subscribe_link, :last_edit_date, :name, :opens, :opt_outs, 
                      :organization_address1, :organization_address2, :organization_address3, :organization_city, 
                      :organization_country, :organization_international_state, :organization_name, :organization_postal_code, 
                      :organization_state, :permission_reminder, :reply_to_email, :sent, :spam_reports, :status, 
                      :style_sheet, :subject, :subscribe_link_text, :view_as_webpage, :view_as_webpage_link_text, :view_as_webpage_text] 
    

    # Setup defaults when creating a new object since
    # CC requires so many extraneous fields to be present
    # when creating a new Campaign.
    def initialize
      obj = super
      obj.set_defaults
      obj
    end
        
    def to_xml
      xml = Builder::XmlMarkup.new
      xml.tag!("Campaign", :xmlns => "http://ws.constantcontact.com/ns/1.0/") do
      	self.attributes.each{ |k, v| xml.tag!(k.to_s.camelize, v) }
        # Overrides the default formatting above to CC's required format.
      	xml.tag!("ReplyToEmail") do
      	  xml.tag!('Email', :id => self.reply_to_email_url)
    	  end
      	xml.tag!("FromEmail") do
      	  xml.tag!('Email', :id => self.from_email_url)
    	  end
      	xml.tag!("ContactLists") do 
      	  xml.tag!("ContactList", :id => self.list_url)
      	end
      end        
    end
    
    def list_url
      id = defined?(self.list_id) ? self.list_id : 1
      List.find(id).id
    end

    def from_email_url
      id = defined?(self.from_email_id) ? self.from_email_id : 1
      EmailAddress.find(id).id
    end

    def reply_to_email_url
      from_email_url
    end
    
    
    protected
    def set_defaults
      self.view_as_webpage                  = 'NO' unless attributes.has_key?('ViewAsWebpage')
      self.from_name                        = self.class.user unless attributes.has_key?('FromName')
      self.permission_reminder              = 'YES' unless attributes.has_key?('PermissionReminder')
      self.permission_reminder_text         = %Q{You're receiving this email because of your relationship with us. Please <ConfirmOptin><a style="color:#0000ff;">confirm</a></ConfirmOptin> your continued interest in receiving email from us.} unless attributes.has_key?('PermissionReminderText')
      self.greeting_salutation              = 'Dear' unless attributes.has_key?('GreetingSalutation')
      self.greeting_name                    = "FirstName"  unless attributes.has_key?('GreetingName')
      self.greeting_string                  = 'Greetings!' unless attributes.has_key?('GreetingString')
      self.status                           = 'DRAFT' unless attributes.has_key?('Status')
      self.style_sheet                      = '' unless attributes.has_key?('StyleSheet')
      self.include_forward_email            = 'NO' unless attributes.has_key?('IncludeForwardEmail')
      self.forward_email_link_text          = '' unless attributes.has_key?('ForwardEmailLinkText')
      self.subscribe_link_text              = '' unless attributes.has_key?('SubscribeLinkText')
      self.include_subscribe_link           = 'NO' unless attributes.has_key?('IncludeSubscribeLink')
      self.organization_name                = self.class.user unless attributes.has_key?('OrganizationName')
      self.organization_address1            = '123 Main' unless attributes.has_key?('OrganizationAddress1')
      self.organization_address2            = '' unless attributes.has_key?('OrganizationAddress2')
      self.organization_address3            = '' unless attributes.has_key?('OrganizationAddress3')
      self.organization_city                = 'Kansas City' unless attributes.has_key?('OrganizationCity')
      self.organization_state               = 'KS' unless attributes.has_key?('OrganizationState')
      self.organization_international_state = '' unless attributes.has_key?('OrganizationInternationalState')
      self.organization_country             = 'US' unless attributes.has_key?('OrganizationCountry')
      self.organization_postal_code         = '64108' unless attributes.has_key?('OrganizationPostalCode')
    end
    
    # Formats data if present.
    def before_save
      self.email_text_content = "<Text>#{email_text_content}</Text>" unless email_text_content.match /^\<Text/
      self.date               = self.date.strftime(DATE_FORMAT) if attributes.has_key?('Date')      
    end
    
    
    def validate
      # NOTE: Needs to be uppercase!
      unless attributes.has_key?('EmailContentFormat') && ['HTML', 'XHTML'].include?(email_content_format)
        errors.add(:email_content_format, 'must be either HTML or XHTML (the latter for advanced email features)') 
      end
      
      if attributes.has_key?('ViewAsWebpage') && view_as_webpage.downcase == 'yes'
        unless attributes['ViewAsWebpageLinkText'].present? && attributes['ViewAsWebpageText'].present?
          errors.add(:view_as_webpage, "You need to set view_as_webpage_link_text and view_as_webpage_link if view_as_webpage is YES")
        end
      end

      errors.add(:email_content, 'cannot be blank') unless attributes.has_key?('EmailContent')       
      errors.add(:email_text_content, 'cannot be blank') unless attributes.has_key?('EmailTextContent') 
      errors.add(:name, 'cannot be blank') unless attributes.has_key?('Name') 
      errors.add(:subject, 'cannot be blank') unless attributes.has_key?('Subject') 
    end
    
  end
end
