require_relative "command_response.rb"
class BotResponse
  attr_reader :bot, :message
  TB = Telegram::Bot
  TBT = TB::Types
  MORE_INFORMATION = TBT::KeyboardButton.new(text: "/Што?")
  KEYBOARD = TBT::ReplyKeyboardMarkup.new(keyboard: [MORE_INFORMATION], resize_keyboard: true)

  def initialize(bot, message)
    @bot = bot
    @message = message
    @@previous_word ||= ""
  end

  def give_response
    if message.text.match(/\//)
      CommandResponse.new(bot, message, @@patience_counter).give_response
    else
      WordInfo.word = message.text
      bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_definition, reply_markup: KEYBOARD)
    end
    define_patience_counter
    @@previous_word = WordInfo.word
  end

  def define_patience_counter
    if WordInfo.the_same_word?(@@previous_word)
      @@patience_counter+=1
    else
      @@patience_counter = 1
    end
  end

end
