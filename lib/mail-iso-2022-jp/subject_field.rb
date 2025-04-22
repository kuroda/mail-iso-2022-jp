# coding: utf-8

require 'mail'

module Mail
  SubjectField.class_eval do
    include FieldWithIso2022JpEncoding
    def b_value_encode(string)
      encode64(string)
    end
  end
end
