# coding: utf-8

module Mail
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
end
