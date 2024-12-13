# frozen_string_literal: true

module Views
  # Parse timestamps from video description
  class Timestamp
    def initialize(description)
      @description = description
    end

    def extract_toc
      # Match timestamps in format HH:MM:SS or MM:SS with any surrounding characters
      # followed by any description text
      timestamps = @description.scan(/[^\d]*(\d{1,2}:\d{2}(?::\d{2})?)[^\w\d]*(.+)/)

      # Clean up and map the matches
      timestamps.map do |time, title|
        # Remove emojis and special characters from title, keeping alphanumeric and basic punctuation
        clean_title = title.gsub(/[\u{1F300}-\u{1F9FF}]/, '') # Remove emojis
          .gsub(/[^\p{L}\p{N}\s\-_.,!?()]/, '') # Keep only alphanumeric and basic punctuation
          .strip

        [time, clean_title] unless clean_title.empty?
      end.compact
    end
  end
end
