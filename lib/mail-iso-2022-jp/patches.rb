# coding:utf-8

require 'mail'
require 'base64'
require 'nkf'

module Mail
  WAVE_DASH = "〜" # U+301C
  FULLWIDTH_TILDE = "～" # U+FF5E
  if RUBY_VERSION >= '1.9'
    ENCODE = {'iso-2022-jp' => Encoding::CP50221}
    def self.encoding_to_charset(str, charset)
      str.encode(ENCODE[charset.to_s.downcase] || charset).force_encoding(charset)
    end
  else
    NKF_OPTIONS = "--oc=CP50220 -xj"
  end

  class InvalidEncodingError < StandardError; end

  class Message
    def body_with_iso_2022_jp_encoding=(value)
      if @charset.to_s.downcase == 'iso-2022-jp'
        if RUBY_VERSION >= '1.9'
          if value.respond_to?(:encoding) && value.encoding.to_s != 'UTF-8'
            raise ::Mail::InvalidEncodingError.new(
              "The mail body is not encoded in UTF-8 but in #{value.encoding}")
          end
        end
      end
      self.body_without_iso_2022_jp_encoding = value
    end
    alias_method :body_without_iso_2022_jp_encoding=, :body=
    alias_method :body=, :body_with_iso_2022_jp_encoding=

    def process_body_raw_with_iso_2022_jp_encoding
      if @charset.to_s.downcase == 'iso-2022-jp'
        @body_raw = @body_raw.to_s.gsub(/#{WAVE_DASH}/, FULLWIDTH_TILDE)
        if RUBY_VERSION >= '1.9'
          @body_raw = Mail.encoding_to_charset(@body_raw, @charset)
        else
          @body_raw = NKF.nkf(NKF_OPTIONS, @body_raw)
        end
      end
      process_body_raw_without_iso_2022_jp_encoding
    end
    alias_method :process_body_raw_without_iso_2022_jp_encoding, :process_body_raw
    alias_method :process_body_raw, :process_body_raw_with_iso_2022_jp_encoding
  end

  class Header
    def encoded
      buffer = ''
      fields.each do |field|
        buffer << field.encoded rescue Encoding::CompatibilityError;
      end
      buffer
    end
  end

  class Body
    def initialize_with_iso_2022_jp_encoding(string = '')
      if string.respond_to?(:encoding) && string.encoding.to_s == 'ISO-2022-JP'
        string.force_encoding('US-ASCII')
      end
      initialize_without_iso_2022_jp_encoding(string)
    end
    alias_method :initialize_without_iso_2022_jp_encoding, :initialize
    alias_method :initialize, :initialize_with_iso_2022_jp_encoding
  end

  class Field
    def initialize_with_iso_2022_jp_encoding(name, value = nil, charset = 'utf-8')
      if charset == 'ISO-2022-JP' && value.kind_of?(String)
        if RUBY_VERSION >= '1.9'
          unless [ 'UTF-8', 'US-ASCII' ].include?(value.encoding.to_s)
            raise ::Mail::InvalidEncodingError.new(
              "The '#{name}' field is not encoded in UTF-8 nor in US-ASCII but in #{value.encoding}")
          end
        end
      end
      initialize_without_iso_2022_jp_encoding(name, value, charset)
    end
    alias_method :initialize_without_iso_2022_jp_encoding, :initialize
    alias_method :initialize, :initialize_with_iso_2022_jp_encoding
  end

  module FieldWithIso2022JpEncoding
    def self.included(base)
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
    def do_decode_with_iso_2022_jp_encoding
      if charset.to_s.downcase == 'iso-2022-jp'
        value
      else
        do_decode_without_iso_2022_jp_encoding
      end
    end

    def encode_with_iso_2022_jp(value, charset)
      value = value.to_s.gsub(/#{WAVE_DASH}/, FULLWIDTH_TILDE)
      if RUBY_VERSION >= '1.9'
        value = Mail.encoding_to_charset(value, charset)
        value.force_encoding('ascii-8bit')
        value = b_value_encode(value)
        value.force_encoding('ascii-8bit')
      else
        value = NKF.nkf(NKF_OPTIONS, value)
        b_value_encode(value)
      end
    end

    def b_value_encode(string)
      string.split(' ').map do |s|
        if s =~ /\e/
          encode64(s)
        else
          s
        end
      end.join(" ")
    end

    private
    def encode(value)
      if charset.to_s.downcase == 'iso-2022-jp'
        value
      else
        super(value)
      end
    end

    def encode_crlf(value)
      if RUBY_VERSION >= '1.9' && charset.to_s.downcase == 'iso-2022-jp'
        value.force_encoding('ascii-8bit')
      end
      super(value)
    end

    def encode64(string)
      "=?ISO-2022-JP?B?#{Base64.encode64(string).gsub("\n", "")}?="
    end
  end

  class SubjectField < UnstructuredField
    include FieldWithIso2022JpEncoding
    def b_value_encode(string)
      encode64(string)
    end
  end

  class FromField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class SenderField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class ToField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class CcField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class ReplyToField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class ResentFromField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class ResentSenderField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class ResentToField < StructuredField
    include FieldWithIso2022JpEncoding
  end

  class ResentCcField < StructuredField
    include FieldWithIso2022JpEncoding
  end
end
