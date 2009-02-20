# i17n - Intranumeralization library for Ruby
# 
# "internationalization".intranumeralize => "i18n"
# "multilingualization".intranumeralize => "m17n"
# "localization".intranumeralize => "l10n"
# "wasteoftimeization".intranumeralize => "w16n"
class String
  def intranumeralize
    raise ArgumentError.new("String to be intranumeralized must be at least 5 characters long and end in -tion") unless length>=5 && self[-4..-1].downcase == 'tion'
    "#{self[0..0]}#{self[1..-2].length}#{self[-1..-1]}"
  end
end

