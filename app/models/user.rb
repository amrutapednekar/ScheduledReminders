class User < ApplicationRecord
    has_secure_password
    # Email address vlidation
    validates :email, presence: true
    validates_uniqueness_of :email
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    #validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
    

    # Password validations
    validates :password_digest, presence: true 
    has_many :reminders
end
