module Mail
  class Preprocessor
    def self.process(value)
      value.to_s.
        gsub(/#{WAVE_DASH}/, FULLWIDTH_TILDE).
        gsub(/#{MINUS_SIGN}/, FULLWIDTH_HYPHEN_MINUS).
        gsub(/#{EM_DASH}/, HORIZONTAL_BAR).
        gsub(/#{DOUBLE_VERTICAL_LINE}/, PARALLEL_TO)
    end
  end
end
