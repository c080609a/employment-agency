class ContactsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ or value =~ /\A\d{10,11}\z/
      record.errors[attribute] << (options[:message] || "is not a valid email or phone number")
    end
  end
end