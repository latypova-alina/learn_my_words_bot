require "dotenv"
Dotenv.load("../stickers_id.env")

class BotResponse
  attr_reader :bot, :message
  TB = Telegram::Bot
  TBT = TB::Types
  MORE_INFORMATION = TBT::KeyboardButton.new(text: "/што?")
  SYNONYMS = TBT::KeyboardButton.new(text: "/а синонимы?")
  KEYBOARD = TBT::ReplyKeyboardMarkup.new(keyboard: [MORE_INFORMATION, SYNONYMS], resize_keyboard: true)

  def initialize(bot, message)
    @bot = bot
    @message = message
    @@previous_word ||= ""
  end

  def give_response
    message.text.match(/\//) ? define_command : give_definition
    define_patience_counter
    @@previous_word = WordInfo.word
  rescue
    error_message
  end

  private

  def define_command
    case message.text
    when "/што?"
      give_translation if no_errors?("translation")
    when "/а синонимы?"
      give_synonyms if no_errors?("syn")
    when "/start"
      start_message
    end
  end

  def error_message
    bot.api.sendMessage(chat_id: message.chat.id, text: "Я бы посоветовал тебе не тратить время на ерунду")
    bot.api.sendSticker(chat_id: message.chat.id, sticker: ENV["ANGRY_STATHAM"])
  end

  def no_errors?(command)
    if WordInfo.no_word?
      give_me_word_message
      return false
    end
    return true if no_command_errors?(command)
    false
  end

  def no_command_errors?(command)
    case command
    when "translation"
      if WordInfo.no_translation?
        dont_know_this_word_message
        return false
      end
    when "syn"
      if WordInfo.no_syn?
        dont_know_this_word_message
        return false
      end
    end
    true
  end

  def give_me_word_message
    send_message("Так не пойдет. Сначала слово")
    send_sticker(ENV["STATHAM_FILE_ID"])
  end

  def send_message(text)
    bot.api.sendMessage(chat_id: message.chat.id, text: text, reply_markup: KEYBOARD)
  end

  def send_sticker(sticker_id)
    bot.api.sendSticker(chat_id: message.chat.id, sticker: sticker_id)
  end

  def dont_know_this_word_message
    send_message("Такого слова я не знаю")
    send_sticker(ENV["STATHAM_DOES_NOT_KNOW"])
  end

  def define_patience_counter
    if WordInfo.the_same_word?(@@previous_word)
      @@patience_counter+=1
    else
      @@patience_counter = 1
    end
  end

  def start_message
    send_message("Всё просто - ты мне английское слово, а я тебе говорю что оно значит, дошло? Начинай")
    send_sticker(ENV["HELLO_FILE_ID"])
  end

  def give_definition
    WordInfo.word = message.text.downcase
    send_message(WordInfo.word_definition)
  end

  def give_translation
    if @@patience_counter > 1
      send_message("Не 'што' а 'что', давай другое слово")
      send_sticker(ENV["STATHAM_FILE_ID"])
    else
      send_message(WordInfo.word_translation)
    end
  end

  def give_synonyms
    send_message(WordInfo.word_synonyms)
  end
end
