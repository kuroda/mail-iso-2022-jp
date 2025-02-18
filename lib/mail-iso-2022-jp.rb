mail_gem = Gem.loaded_specs["mail"] || Gem::Specification.find_all_by_name("mail").first
if mail_gem.version.to_s >= '2.8.0'
  # New code
  require 'mail-iso-2022-jp/character_names'
  require 'mail-iso-2022-jp/invalid_encoding_error'
  require 'mail-iso-2022-jp/common_methods_for_field'
  require 'mail-iso-2022-jp/preprocessor'
  require 'mail-iso-2022-jp/mail'
  require 'mail-iso-2022-jp/message'
  require 'mail-iso-2022-jp/field'
  require 'mail-iso-2022-jp/field_with_iso_2022_jp_encoding'
  require 'mail-iso-2022-jp/body'
  require 'mail-iso-2022-jp/header'
  require 'mail-iso-2022-jp/subject_field'
  require 'mail-iso-2022-jp/structured_fields'
else
  # Old code
  require 'mail-iso-2022-jp/mail_under_280/character_names'
  require 'mail-iso-2022-jp/mail_under_280/invalid_encoding_error'
  require 'mail-iso-2022-jp/mail_under_280/common_methods_for_field'
  require 'mail-iso-2022-jp/mail_under_280/preprocessor'

  if RUBY_VERSION >= '1.9'
    require 'mail-iso-2022-jp/mail_under_280/mail'
    require 'mail-iso-2022-jp/mail_under_280/message'
    require 'mail-iso-2022-jp/mail_under_280/field'
    require 'mail-iso-2022-jp/mail_under_280/field_with_iso_2022_jp_encoding'
    require 'mail-iso-2022-jp/mail_under_280/body'
  else
    require 'mail-iso-2022-jp/ruby18/mail'
    require 'mail-iso-2022-jp/ruby18/message'
    require 'mail-iso-2022-jp/ruby18/field_with_iso_2022_jp_encoding'
  end

  require 'mail-iso-2022-jp/mail_under_280/header'
  require 'mail-iso-2022-jp/mail_under_280/subject_field'
  require 'mail-iso-2022-jp/mail_under_280/structured_fields'
end
