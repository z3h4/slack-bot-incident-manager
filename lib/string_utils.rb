class StringUtils
  def self.pluralize(count, singular, plural = nil)
    if count == 1
      singular
    elsif plural
      plural
    else
      "#{singular}s"
    end
  end
end
