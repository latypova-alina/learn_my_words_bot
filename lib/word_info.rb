require "dotenv"
require_relative "lingvo.rb"
require_relative "mashape.rb"
Dotenv.load("../.env")

class WordInfo
  class << self
    attr_accessor :word

    def word_translation
      response = Lingvo.translation(word)
      JSON.parse(response.body)["Translation"]["Translation"]
    end

    def word_definition
      line = ""
      response = Mashape.definition(word)
      JSON.parse(response.body)["results"].each do |d|
        line << "#{d['definition'].capitalize}\n\n"
      end
      line
    end

    def the_same_word?(previous_word)
      word == previous_word
    end
  end
end
