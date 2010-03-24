module ConstantContact
  class List < Base

    # @@column_names = [:contact_count, :display_on_signup, :members, :name, :opt_in_default, :short_name, :sort_order]    
    
    def self.find_by_name(name)
      lists = self.find :all
      lists.find{|list| list.Name == name}
    end
  end
end
