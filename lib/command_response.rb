class CommandResponse
  attr_reader :command, :patience_counter, :bot, :message
  TB = Telegram::Bot
  TBT = TB::Types
  MORE_INFORMATION = TBT::KeyboardButton.new(text: "/Што?")
  KEYBOARD = TBT::ReplyKeyboardMarkup.new(keyboard: [MORE_INFORMATION], resize_keyboard: true)
  STATHAM_FILE_ID = "CAADBAADiAIAAoVpUQWeomfO2K5XagI"

  def initialize(bot, message, patience_counter)
    @command = message.text
    @bot = bot
    @message = message
    @patience_counter = patience_counter
  end

  def give_response
    case command
    when "/Што?"
      give_definition
    end
  end

  private

  def give_definition
    if patience_counter > 1
      bot.api.sendMessage(chat_id: message.chat.id, text: "Не 'што' а 'что', давай уже другое слово", reply_markup: KEYBOARD)
      bot.api.sendSticker(chat_id: message.chat.id, sticker: STATHAM_FILE_ID)
    else
      bot.api.sendMessage(chat_id: message.chat.id, text: WordInfo.word_translation, reply_markup: KEYBOARD)
    end
  end
end
