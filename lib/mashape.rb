class Mashape
  class << self
    def definition(word)
      HTTParty.get("https://wordsapiv1.p.mashape.com/words/#{word}",
        headers: mashape_headers)
    end

    private

    def mashape_headers
      { "X-Mashape-Key" => ENV["WORDSAPI_TOKEN"] }
    end
  end
end
