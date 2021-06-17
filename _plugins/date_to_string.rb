module Jekyll::Filters
  # Use %e instead of %d (leading 0 looks ugly)
  def date_to_string date
    time(date).strftime('%e %b %Y').strip
  end
end

module Jekyll::DateToStringSpaceFilter
  # Use a space instead of a 0; makes it aligned with monospace fonts.
  def date_to_string_space date
    fmt = time(date).strftime('%d %b %Y').strip
    fmt[0] = "\u00a0" if fmt[0] == '0'
    return fmt
  end
end
Liquid::Template.register_filter(Jekyll::DateToStringSpaceFilter)
