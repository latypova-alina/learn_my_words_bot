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
    rescue
      nil
    end

    def word_definition
      line = ""
      response = Mashape.information(word)
      JSON.parse(response.body)["results"].each do |d|
        line << "#{d['definition'].capitalize}\n\n"
      end
      line
    rescue
      nil
    end

    def word_synonyms
      line = ""
      response = Mashape.information(word)
      JSON.parse(response.body)["results"].each do |d|
        line << "#{d['synonyms'].first.capitalize}\n\n" if d['synonyms']
      end
      line
    rescue
      nil
    end

    def the_same_word?(previous_word)
      word == previous_word
    end

    def no_definition?
      word_definition == nil
    end

    def no_translation?
      word_translation == nil
    end

    def no_word?
      word == nil
    end

  end
end
