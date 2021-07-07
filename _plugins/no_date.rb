class Jekyll::PostReader
  # Don't use DATE_FILENAME_MATCHER so we don't need to put those stupid dates
  # in the filename. Also limit to just *.markdown, so it won't process binary
  # files from e.g. drags.
  def read_posts(dir)
    read_publishable(dir, "_posts", /.*\.(markdown|md)$/)
  end
  def read_drafts(dir)
    read_publishable(dir, "_drafts", /.*\.(markdown|md)$/)
  end
end

