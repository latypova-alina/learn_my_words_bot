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
      line = "#{word_transcription}\n\n"
      JSON.parse(response.body)["results"].each do |d|
        line << "#{d['definition'].capitalize}\n\n"
      end
      line
    rescue
      nil
    end

    def word_transcription
      body = JSON.parse(Mashape.information(word).body)
      "#{body['word'].capitalize} [#{body['pronunciation']['all']}]"
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

    def definition?
      !word_definition.empty? && word_definition
    end

    def translation?
      !word_translation.empty? && word_translation
    end

    def word?
      word
    end

    def syn?
      word_synonyms && !word_synonyms.empty?
    end
  end
end
