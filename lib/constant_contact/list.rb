module ConstantContact
  class List < Base
    
    def self.find_by_name(name)
      lists = self.find :all
      lists.find{|list| list.Name == name}
    end
  end
end
