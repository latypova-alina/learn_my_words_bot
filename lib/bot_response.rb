class BotResponse
  attr_reader :bot, :message
  TB = Telegram::Bot
  TBT = TB::Types
  MORE_INFORMATION = TBT::KeyboardButton.new(text: "/Што?")
  KEYBOARD = TBT::ReplyKeyboardMarkup.new(keyboard: [MORE_INFORMATION], resize_keyboard: true)
  STATHAM_FILE_ID = "CAADBAADiAIAAoVpUQWeomfO2K5XagI"

  def initialize(bot, message)
    @bot = bot
    @message = message
    @@previous_word ||= ""
  end

  def give_response
    if message.text.match(/\//)
      give_translation
    else
      give_definition
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

  def give_definition
    WordInfo.word = message.text
    bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_definition, reply_markup: KEYBOARD)
  end

  def give_translation
    if @@patience_counter > 1
      bot.api.sendMessage(chat_id: message.chat.id, text: "Не 'што' а 'что', давай другое слово", reply_markup: KEYBOARD)
      bot.api.sendSticker(chat_id: message.chat.id, sticker: STATHAM_FILE_ID)
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_translation, reply_markup: KEYBOARD)
    end
  end

end
