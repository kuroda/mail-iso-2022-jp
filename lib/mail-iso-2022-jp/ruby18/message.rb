require 'mail'
require 'nkf'

# Patches for Mail::Message on Ruby 1.8.7
module Mail
  class Message
    def body_with_iso_2022_jp_encoding=(value)
      self.body_without_iso_2022_jp_encoding = value
    end
    alias_method :body_without_iso_2022_jp_encoding=, :body=
    alias_method :body=, :body_with_iso_2022_jp_encoding=

    def process_body_raw_with_iso_2022_jp_encoding
      if @charset.to_s.downcase == 'iso-2022-jp'
        @body_raw = Mail::Preprocessor.process(@body_raw)
        @body_raw = NKF.nkf(NKF_OPTIONS, @body_raw)
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
