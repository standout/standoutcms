class MemberSerializer < ActiveModel::Serializer
  attributes :id,
             :approved,
             :email,
             :username,
             :first_name,
             :last_name,
             :postal_street,
             :postal_zip,
             :postal_city,
             :phone,
             :full_name,
             :full_address
end
