# coding: utf-8

module Mail
  class Header
    def encoded
      buffer = ''
      fields.each do |field|
        buffer << field.encoded rescue Encoding::CompatibilityError
      end
      buffer
    end
  end
end
