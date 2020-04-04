require 'securerandom'


class Player

  VERSION = "Getting a little smarter"

  def bet_request(game_state)
    safe_bet(game_state)
  rescue
    0
  end

  def showdown(game_state)

  end

  private

  def safe_bet(game_state)
    me = game_state['players'][game_state['in_action']]
    my_cards = me['hole_cards']
    if my_cards[0]['rank'] == my_cards[1]['rank']
      10000
    else
      if SecureRandom.random_number <0.1
        10000
      else
        0
      end
    end
  end

  def chen_score(game_state)

  end
end
