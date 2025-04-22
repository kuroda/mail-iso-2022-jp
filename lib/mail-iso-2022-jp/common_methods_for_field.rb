module Mail
  module CommonMethodsForField
    private
    def do_decode_with_iso_2022_jp_encoding
      if charset.to_s.downcase == 'iso-2022-jp'
        value
      else
        do_decode_without_iso_2022_jp_encoding
      end
    end

    def b_value_encode(string)
      string.split(' ').map do |s|
        if s =~ /\e/ || s == "\"" || start_with_specials?(s) || end_with_specials?(s)
          encode64(s)
        else
          s
        end
      end.join(" ")
    end

    def encode(value)
      if charset.to_s.downcase == 'iso-2022-jp'
        value
      else
        super(value)
      end
    end

    def encode64(string)
      if string.length > 0
        "=?ISO-2022-JP?B?#{Base64.encode64(string).gsub("\n", "")}?="
      else
        string
      end
    end

    def preprocess(value)
      value = value.to_s.gsub(/#{WAVE_DASH}/, FULLWIDTH_TILDE)
      value = value.to_s.gsub(/#{MINUS_SIGN}/, FULLWIDTH_HYPHEN_MINUS)
      value = value.to_s.gsub(/#{EM_DASH}/, HORIZONTAL_BAR)
      value = value.to_s.gsub(/#{DOUBLE_VERTICAL_LINE}/, PARALLEL_TO)
      value
    end

    def start_with_specials?(string)
      string =~ /\A[\(\)<>\[\]:;@\\,\."]+[a-zA-Z]+\Z/
    end

    def end_with_specials?(string)
      string =~ /\A[a-zA-Z]+[\(\)<>\[\]:;@\\,\."]+\Z/
    end
  end
end
