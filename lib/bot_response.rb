class BotResponse
  attr_reader :bot, :message
  TB = Telegram::Bot
  TBT = TB::Types
  MORE_INFORMATION = TBT::KeyboardButton.new(text: "/што?")
  SYNONYMS = TBT::KeyboardButton.new(text: "/а синонимы?")
  KEYBOARD = TBT::ReplyKeyboardMarkup.new(keyboard: [MORE_INFORMATION, SYNONYMS], resize_keyboard: true)
  STATHAM_FILE_ID = "CAADBAADiAIAAoVpUQWeomfO2K5XagI"
  HELLO_FILE_ID = "CAADBAADqQIAAoVpUQV8lGGpxy7bLwI"
  STATHAM_DOES_NOT_KNOW = "CAADBAADpwIAAoVpUQULoMsJeHJ5dQI"
  ANGRY_STATHAM = "CAADBAADowIAAoVpUQUe179jKBFMmAI"

  def initialize(bot, message)
    @bot = bot
    @message = message
    @@previous_word ||= ""
  end

  def give_response
    if message.text.match(/\//)
      define_command
    else
      give_definition
    end
    define_patience_counter
    @@previous_word = WordInfo.word
  rescue
    bot.api.sendMessage(chat_id: message.chat.id, text: "Я бы посоветовал тебе не тратить время на ерунду")
    bot.api.sendSticker(chat_id: message.chat.id, sticker: ANGRY_STATHAM)
  end

  def define_command
    case message.text
    when "/што?"
      if WordInfo.no_word?
        bot.api.sendMessage(chat_id: message.chat.id, text: "Так не пойдет. Сначала слово")
        bot.api.sendSticker(chat_id: message.chat.id, sticker: STATHAM_FILE_ID)
      elsif WordInfo.no_definition? || WordInfo.no_translation?
        bot.api.sendMessage(chat_id: message.chat.id, text: "Такого слова я не знаю")
        bot.api.sendSticker(chat_id: message.chat.id, sticker: STATHAM_DOES_NOT_KNOW)
      else
        give_translation
      end
    when "/а синонимы?"
      give_synonyms
    when "/start"
      start_message
    end
  end

  def define_patience_counter
    if WordInfo.the_same_word?(@@previous_word)
      @@patience_counter+=1
    else
      @@patience_counter = 1
    end
  end

  def start_message
    bot.api.sendMessage(chat_id: message.chat.id, text: "Всё просто - ты мне английское слово, а я тебе говорю что оно значит, дошло? Начинай")
    bot.api.sendSticker(chat_id: message.chat.id, sticker: HELLO_FILE_ID)
  end

  def give_definition
    WordInfo.word = message.text.downcase
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

  def give_synonyms
    bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_synonyms, reply_markup: KEYBOARD)
  end
end
