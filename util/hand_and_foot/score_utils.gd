extends Node

class_name HandAndFootUtil

static func get_card_score(card:CardModel)->int:
	# Returns the point value of a card
	var value = card.get_value()
	if value < 3: # wild cards
		return 20
	elif value < 4:
		if card.get_suit() == CardModel.Suits.CLUBS or CardModel.Suits.SPADES:
			return 5 # Black 3s
		else:
			return 50 # Red 3s
	elif value < 9:
		return 5
	elif value < 14:
		return 10
	else:
		return 50
