require 'securerandom'


class Player

  VERSION = "Scoring scoring scoring"

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
    if chen_score my_cards > 6
      10000
    else
      0
    end
  end

  def chen_score(my_cards)
    score = my_cards.map { |card| card_score card }.max
    score *= 2 if pair?(my_cards)
    score
  end

  def pair?(my_cards)
    my_cards[0]['rank'] == my_cards[1]['rank']
  end

  def card_score(card)
    values = { 'J' => 6, 'Q' => 7, 'K' => 8, 'A' => 10 }
    if values.key? card['rank']
      return values[card['rank']]
    end
    card['rank']/2
  end
end
