class User < ActiveRecord::Base
  has_many :contacts
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   # Virtual attribute for authenticating by either username or email
   # This is in addition to a real persisted field like 'username'
   attr_accessor :login

   def self.find_first_by_auth_conditions(warden_conditions)
     conditions = warden_conditions.dup
     if login = conditions.delete(:login)
       where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
     else
       if conditions[:username].nil?
         where(conditions).first
       else
         where(username: conditions[:username]).first
       end
     end
   end

   validates :username, :presence => true, :uniqueness => { :case_sensitive => false }

end
