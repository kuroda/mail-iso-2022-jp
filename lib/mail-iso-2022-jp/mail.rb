# coding: utf-8

module Mail
  ENCODE = { 'iso-2022-jp' => Encoding::CP50221 }

  def self.encoding_to_charset(str, charset)
    str.encode(ENCODE[charset.to_s.downcase] || charset, :undef => :replace).force_encoding(charset)
  end
end
