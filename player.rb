require 'securerandom'


class Player

  VERSION = "Wait for it..."

  def bet_request(game_state)
    safe_bet(game_state)
  rescue StandardError => e
    STDERR.puts "[ERROR] " + e.message
    STDERR.puts e.backtrace
    0
  end

  def showdown(game_state)

  end

  private

  def safe_bet(game_state)
    me = game_state['players'][game_state['in_action']]
    my_cards = me['hole_cards']

    #active_players = game_state['players'].map { |player| player['status'] == 'active' ? 1 : 0 }.sum
    #cutoff = active_players > 2 ? 10 : 7
    cutoff = 7

    position = [2,3,1][game_state['dealer']]
    chen_score = chen_score my_cards
    bet = (chen_score > cutoff - position) ? 10000 : 0

    STDERR.puts  "[MAKE BET] " + my_cards.map { |card| "#{card['rank']} of #{card['suit']}" }.join(' and ') + " > #{chen_score} >  #{bet}"

    bet
  end

  def chen_score(my_cards)
    score = max_card_value(my_cards)
    score *= 2 if pocket_pair? my_cards
    score += 2 if suited_pocket? my_cards
    score += pocket_gap_score my_cards
    score += 1 if max_card_numeric_value(my_cards) < 12 and pocket_gap(my_cards) < 2
    score.ceil
  end

  def max_card_value(my_cards)
    my_cards.map { |card| card_score card }.max
  end

  def max_card_numeric_value(my_cards)
    my_cards.map { |card| card_numeric_value card }.max
  end

  def pocket_pair?(my_cards)
    my_cards[0]['rank'] == my_cards[1]['rank']
  end

  def suited_pocket?(my_cards)
    my_cards[0]['suit'] == my_cards[1]['suit']
  end

  def pocket_gap(my_cards)
    (card_numeric_value(my_cards[0]) - card_numeric_value(my_cards[1])).abs
  end

  def pocket_gap_score(my_cards)
    gap = pocket_gap my_cards
    return -5 if gap >= 4
    [0, -1, -2, -4][gap]
  end

  def card_score(card)
    values = { 'J' => 6, 'Q' => 7, 'K' => 8, 'A' => 10 }
    if values.key? card['rank']
      return values[card['rank']]
    end
    card['rank'].to_i/2
  end

  def card_numeric_value(card)
    values = { 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14 }
    if values.key? card['rank']
      return values[card['rank']]
    end
    card['rank'].to_i
  end
end
