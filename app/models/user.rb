class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         

   ##
   # List of roles. Later roles are assumed to have all the same
   # privileges as roles below. For instance, :admin will have
   # the same abilities of :guest and :user. However, :user may
   # not have all the same abilities as :admin and :owner.
   # ROLES are enumerated to allow for ordinal testing.
   #
   ROLES = [:guest, :user, :manager, :admin]
   enum role: ROLES
   
   ##
   # Creates methods to test of a user is allowed to act as a role.
   # Given ROLES = [:guest, :user, :admin, :owner], will create the methods
   # #can_be_guest?, #can_be_user?, #can_be_admin? and #can_be_owner?.
   #
   # The methods return true if the user's role is equal to or less than the rank of the
   # can_be method. So if a user is an admin, #can_be_user? or #can_be_admin? would return true, but
   # can_be_owner? would return false.
   #
   ROLES.each do |role_name|
     define_method("can_be_#{role_name}?") do 
       self.class.roles[role_name] <= self.class.roles[self.role]
     end
   end
end
