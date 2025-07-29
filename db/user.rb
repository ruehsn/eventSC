class User < ApplicationRecord
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
