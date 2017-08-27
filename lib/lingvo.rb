class Lingvo
  LINGVO_URL = "https://developers.lingvolive.com/api".freeze
  class << self
    def translation(word)
      HTTParty.get("#{LINGVO_URL}/v1/Minicard?text=#{word}&srcLang=1033&dstLang=1049&isCaseSensitive=false",
        headers: lingvo_headers).body
    end

    private

    def lingvo_token
      HTTParty.post("#{LINGVO_URL}/v1.1/authenticate",
        headers: { "Authorization" => "Basic #{ENV['LINGVO_KEY']}" }).body
    end

    def lingvo_headers
      { "Authorization" => "Bearer #{lingvo_token}" }
    end
  end
end
