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
    message.text.match(%r{/}) ? define_command : give_definition
    define_patience_counter
    @@previous_word = WordInfo.word
  rescue
    unknown_error_message
  end

  private

  def define_command
    command = message.text
    give_translation if translation?(command)
    give_synonyms if syn?(command)
    start_message if command == "/start"
    give_error_message(command) unless no_errors?(command)
  end

  def unknown_error_message
    bot.api.sendMessage(chat_id: message.chat.id, text: "Я бы посоветовал тебе не тратить время на ерунду")
    bot.api.sendSticker(chat_id: message.chat.id, sticker: ENV["ANGRY_STATHAM"])
  end

  def no_errors?(command)
    return true if command == "/start"
    command == "/а синонимы?" ? WordInfo.syn? : WordInfo.translation?
  end

  def give_error_message(command)
    give_me_word_message if no_word?(command)
    dont_know_this_word_message if dont_know_error?(command)
  end

  def no_word?(command)
    command == "/што?" && !WordInfo.word?
  end

  def translation?(command)
    command == "/што?" && WordInfo.translation?
  end

  def syn?(command)
    command == "/а синонимы?" && WordInfo.syn?
  end

  def unknown_word?
    !WordInfo.definition?
  end

  def dont_know_error?(command)
    !translation?(command) || !syn?(command) || unknown_word?
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
      @@patience_counter += 1
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
    if @@patience_counter > 2
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
