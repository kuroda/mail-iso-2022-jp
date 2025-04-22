# coding: utf-8

require 'mail'

# Patches for Mail::Message on Ruby 1.9.x or above
module Mail
  class Message
    def body_with_iso_2022_jp_encoding=(value)
      if @charset.to_s.downcase == 'iso-2022-jp'
        if value.respond_to?(:encoding) && value.encoding.to_s != 'UTF-8'
          raise ::Mail::InvalidEncodingError.new(
            "The mail body is not encoded in UTF-8 but in #{value.encoding}")
        end
        value = Mail::Preprocessor.process(value)
      end
      self.body_without_iso_2022_jp_encoding = value
    end
    alias_method :body_without_iso_2022_jp_encoding=, :body=
    alias_method :body=, :body_with_iso_2022_jp_encoding=

    def process_body_raw_with_iso_2022_jp_encoding
      if @charset.to_s.downcase == 'iso-2022-jp'
        @body_raw = Mail.encoding_to_charset(@body_raw, @charset)
      end
      process_body_raw_without_iso_2022_jp_encoding
    end
    alias_method :process_body_raw_without_iso_2022_jp_encoding, :process_body_raw
    alias_method :process_body_raw, :process_body_raw_with_iso_2022_jp_encoding

    def text_part_with_iso_2022_jp_encoding=(msg = nil)
      if @charset.to_s.downcase == 'iso-2022-jp' && msg && msg.charset.nil?
        msg.charset = @charset
      end
      self.text_part_without_iso_2022_jp_encoding = msg
    end
    alias_method :text_part_without_iso_2022_jp_encoding=, :text_part=
    alias_method :text_part=, :text_part_with_iso_2022_jp_encoding=
  end
end
