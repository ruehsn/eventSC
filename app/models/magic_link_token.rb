class MagicLinkToken < ApplicationRecord
  AUTO_GENERATED_PASSWORD = SecureRandom.hex(32)

  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email_address, :string
  validates :email_address, presence: true
  validates :email_address, is_not_spam: true

  def save
    return unless valid?

    User.where(email_address: email_address).first_or_create.tap do |user|
      if user.new_record?
        user.password = AUTO_GENERATED_PASSWORD

        user.save

        create_workspace_for user
      end

      send_magic_link_to user
    end
  end    
end
