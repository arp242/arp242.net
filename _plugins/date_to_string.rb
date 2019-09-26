module Jekyll::Filters
  # Use %e instead of %d (leading 0 looks ugly)
  def date_to_string date
    time(date).strftime('%e %b %Y').strip
  end
end
