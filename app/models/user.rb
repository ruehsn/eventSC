class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    
    # In production, enforce domain restriction
    validates :email, format: { 
      with: /@shepherdscollege\.edu\z/, 
      message: "must be a @shepherdscollege.edu email address" 
    }, unless: -> { Rails.env.development? }

    generates_token_for :magic_login, expires_in: 1.hour do
        last_sign_in_at
    end

    # Admin functionality
    def admin?
        is_admin?
    end

    def make_admin!
        update!(is_admin: true)
    end

    def remove_admin!
        update!(is_admin: false)
    end
end
