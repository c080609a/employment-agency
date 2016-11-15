class ContactsValidator < ActiveModel::Validator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)`[a-z]{2,})\z/i or value =~ /\A\d{10,11}\z/
      record.errors[attribute] << (options[:message] || "is not a valid email or phone number")
    end
  end
end