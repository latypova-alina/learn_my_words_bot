require "telegram/bot"
require "httparty"
require "pry"
require_relative "word_info.rb"
require_relative "bot_response.rb"

TB = Telegram::Bot
TB::Client.run(ENV["TELEGRAM_TOKEN"]) do |bot|
  bot.listen do |message|
    BotResponse.new(bot, message).give_response
  end
end
