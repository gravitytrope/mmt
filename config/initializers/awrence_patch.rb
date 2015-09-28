# Patch the awrence gem to UPCASE keys that we don't want CamelCase

class Hash
  private

  UPCASE_WORDS = %w(
    urls
    isbn
    doi
    iso_topic_categories
  )

  def camelize(snake_word, first_upper = true)
    # Here is the patch
    if UPCASE_WORDS.include?(snake_word)
      return 'URLs' if snake_word == 'urls'
      return 'ISOTopicCategories' if snake_word == 'iso_topic_categories'
      return snake_word.upcase
    end

    if first_upper
      snake_word.to_s.gsub(/\/(.?)/) { '::' + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      snake_word.chars.first + camelize(snake_word)[1..-1]
    end
  end
end
