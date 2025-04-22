# coding: utf-8

module Mail
  Header.class_eval do
    def encoded
      buffer = ''
      fields.each do |field|
        buffer << field.encoded rescue Encoding::CompatibilityError
      end
      buffer
    end
  end
end
