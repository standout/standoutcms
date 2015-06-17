# Replace default has_secure_password validations with a version that allows
# create without them
# Instead it is activated when approved is set to true
# Usage:
#   create_table :members do |t|
#     t.boolean :approved, default: false
#   end
#   class MyModel < ActiveModel::Base
#     has_secure_password validations: false
#     include HasSecurePasswordWhenApproved
#   end
# Default validation code is found here:
# rails/rails/blob/4-0-stable/activemodel/lib/active_model/secure_password.rb
module HasSecurePasswordWhenApproved
  extend ActiveSupport::Concern

  included do
    # This ensures the model has a password by checking whether the password_digest
    # is present, so that this works with both new and existing records. However,
    # when there is an error, the message is added to the password attribute instead
    # so that the error message will make sense to the end-user.
    validate do |record|
      next unless approved?
      errors.add(:password, :blank) unless record.password_digest.present?
    end

    validates :password_confirmation, presence: true,
      if: ->(model) { model.password.present? }
    validates :password, confirmation: true
  end
end
