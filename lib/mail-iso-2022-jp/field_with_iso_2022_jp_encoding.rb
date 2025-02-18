# coding: utf-8

require 'mail'
require 'base64'

module Mail
  module FieldWithIso2022JpEncoding
    def self.included(base)
      base.send :include, Mail::CommonMethodsForField
      base.send :alias_method, :initialize_without_iso_2022_jp_encoding, :initialize
      base.send :alias_method, :initialize, :initialize_with_iso_2022_jp_encoding
      base.send :alias_method, :do_decode_without_iso_2022_jp_encoding, :do_decode
      base.send :alias_method, :do_decode, :do_decode_with_iso_2022_jp_encoding
    end

    def initialize_with_iso_2022_jp_encoding(value = nil, charset = 'utf-8')
      if charset.to_s.downcase == 'iso-2022-jp'
        if value.kind_of?(Array)
          value = value.map { |e| encode_with_iso_2022_jp(e, charset) }
        else
          value = encode_with_iso_2022_jp(value, charset)
        end
      end
      initialize_without_iso_2022_jp_encoding(value, charset)
    end

    private
    def encode_with_iso_2022_jp(value, charset)
      value = Mail::Preprocessor.process(value)
      value = Mail.encoding_to_charset(value, charset)
      value.force_encoding('ascii-8bit')
      value = b_value_encode(value)
      value.force_encoding('ascii-8bit')
    end

    def encode_crlf(value)
      if charset.to_s.downcase == 'iso-2022-jp'
        value.force_encoding('ascii-8bit')
      end
      super(value)
    end
  end
end
