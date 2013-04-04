# coding: utf-8

require 'mail'

module Mail
  class Field
    def initialize_with_iso_2022_jp_encoding(name, value = nil, charset = 'utf-8')
      if charset == 'ISO-2022-JP' && value.kind_of?(String)
        unless [ 'UTF-8', 'US-ASCII' ].include?(value.encoding.to_s)
          raise ::Mail::InvalidEncodingError.new(
            "The '#{name}' field is not encoded in UTF-8 nor in US-ASCII but in #{value.encoding}")
        end
      end
      charset = 'utf-8' if already_encoded?(name, charset)
      initialize_without_iso_2022_jp_encoding(name, value, charset)
    end
    alias_method :initialize_without_iso_2022_jp_encoding, :initialize
    alias_method :initialize, :initialize_with_iso_2022_jp_encoding

    private
    def already_encoded?(name, charset)
      true if charset == 'ISO-2022-JP' && name =~ /(^Subject:\ \=\?ISO-2022-JP\?)/
    end
  end
end
