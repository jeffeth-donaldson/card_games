extends Node
class_name Canasta

var cards:Array[Card]
var card_num:int = -1
var wild_cards:Array[int]
var wild_count:int = 0

func _init(game_wild_cards:Array[int]) -> void:
	wild_cards = game_wild_cards
	cards = []

func is_clean() -> bool:
	return wild_count == 0

func add_cards(new_cards:Array[Card]) -> bool:
	# Checks to make sure that cards can be added
	# If so, adds cards and returns true
	# If not, does nothing and returns false
	# Caller cannot assume that canasta will take cards
	#
	# Rules for Canasta:
	# Cards must have the same suit unless wild
	# There cannot be more wilds than naturals in the canasta
	var new_wild_count:int = wild_count
	var new_len:int = len(cards)
	var new_card_num:int
	for card in new_cards:
		if card.card_model.card_num in wild_cards:
			new_wild_count += 1
			new_len += 1
		elif card_num == -1:
			new_card_num = card.card_model.get_value()
			new_len += 1
		elif card.card_model.get_value() != card_num:
			printerr("Card Value: ",card.card_model.get_value(),"Does not match canasta of value:",card_num)
			return false
		else:
			new_len += 1
	if new_wild_count > new_len - new_wild_count:
		printerr("Cannot add cards, there would be more wilds than naturals")
		return false
	else:
		wild_count = new_wild_count
		for card in new_cards:
			card.reparent(self)
			card.set_on_hover(func (): pass)
			card.set_on_leave(func (): pass)
		return true
