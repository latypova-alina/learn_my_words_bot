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
      response = Mashape.information(word)
      body = JSON.parse(response.body)
      line = "#{body['word'].capitalize} [#{body['pronunciation']['all']}]\n\n"
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
        line << "#{d['synonyms'].first.capitalize}\n\n" if d["synonyms"]
      end
      line
    rescue
      nil
    end

    def the_same_word?(previous_word)
      word == previous_word
    end

    def no_definition?
      word_definition.empty? || word_definition.nil?
    end

    def no_translation?
      word_translation.empty? || word_translation.nil?
    end

    def no_word?
      word.nil?
    end

    def no_syn?
      word_synonyms.nil? || word_synonyms.empty?
    end
  end
end
