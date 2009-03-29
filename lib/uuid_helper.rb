module UuidHelper
  require 'uuidtools'
  
  def generate_uuid()
    
    if self.new_record?
      
      self.uuid = UUID.random_create().to_s
      
    end
    
  end
  
end