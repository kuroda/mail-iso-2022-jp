# coding: utf-8

require 'mail'

module Mail
  [FromField, SenderField, ToField, CcField, ReplyToField, ResentFromField, ResentSenderField, ResentToField, ResentCcField].each do |field_class|
    field_class.class_eval do
      include FieldWithIso2022JpEncoding
    end
  end
end
