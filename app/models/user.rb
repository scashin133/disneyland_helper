class User < ActiveRecord::Base
  set_primary_key "uuid"
  include UuidHelper
  
end
