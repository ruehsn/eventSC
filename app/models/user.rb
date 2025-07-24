class User < ApplicationRecord
    generates_token_for :magic_login, expires_in: 1.hour do
        last_sign_in_at
    end
end
