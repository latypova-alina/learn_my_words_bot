require "telegram/bot"
require "httparty"
require "pry"
require_relative "word_info.rb"

TB = Telegram::Bot
TBT = TB::Types

more_information = TBT::KeyboardButton.new(text: "Што?")
keyboard = TBT::ReplyKeyboardMarkup.new(keyboard: [more_information], resize_keyboard: true)
TB::Client.run(ENV["TELEGRAM_TOKEN"]) do |bot|
  bot.listen do |message|
    if message.text == "Што?"
      bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_translation, reply_markup: keyboard)
    else
      WordInfo.word = message.text
      bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_definition, reply_markup: keyboard)
    end
  end
end
