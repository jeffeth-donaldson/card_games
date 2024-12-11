extends StaticBody3D
class_name Canasta

const CANASTA_LENGTH:int = 7
const CARD_SPEED:float = 1.0
const CARD_DISTNACE:float = 0.2

var cards:Array[Card]
var card_num:int = -1
var wild_cards:Array[int]
var wild_count:int = 0
var model_changed:bool = false
var movement_component:StaticMovementComponent = StaticMovementComponent.new(self, StaticMovementComponent.MOVEMENT_KIND.SIMPLE)
var DebugCube = preload("res://entities/debug/debug_cube.tscn")

func _init(game_wild_cards:Array[int]) -> void:
	# Debug Cube
	#var d_cube = DebugCube.instantiate()
	#add_child(d_cube)
	wild_cards = game_wild_cards
	cards = []

func is_clean() -> bool:
	return wild_count == 0

func is_finished() -> bool:
	return len(cards) > 6

func is_valid() -> bool:
	return len(cards) > 2

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
	for card in new_cards:
		if card.card_model.card_num in wild_cards:
			new_wild_count += 1
		elif card_num == -1:
			card_num = card.card_model.get_value()
		elif card.card_model.get_value() != card_num:
			printerr("Card Value: ",card.card_model.get_value(),"Does not match canasta of value:",card_num)
			return false
		new_len += 1
	if new_wild_count > new_len - new_wild_count:
		printerr("Cannot add cards, there would be more wilds than naturals")
		return false
	else:
		model_changed = true
		wild_count = new_wild_count
		for card in new_cards:
			cards.append(card)
			card.reparent(self)
			card.set_on_hover(func (point): pass)
			card.set_on_leave(func (point): pass)
		return true

func _process(delta: float) -> void:
	movement_component.process(delta)
	if model_changed:
		var y_offset = 0
		if len(cards) >= CANASTA_LENGTH:
			var card_suit = cards.back().get_suit()
			if wild_count == 0:
				if card_suit == CardModel.Suits.CLUBS or card_suit == CardModel.Suits.SPADES:
					for i in range(len(cards)):
						var new_suit = cards[i].get_suit()
						if new_suit == CardModel.Suits.HEARTS or new_suit == CardModel.Suits.DIAMONDS:
							var topcard = cards.pop_at(i)
							cards.append(topcard)
							break
			else:
				if card_suit == CardModel.Suits.HEARTS or card_suit == CardModel.Suits.DIAMONDS:
					for i in range(len(cards)):
						var new_suit = cards[i].get_suit()
						if new_suit == CardModel.Suits.SPADES or new_suit == CardModel.Suits.CLUBS:
							var topcard = cards.pop_at(i)
							cards.append(topcard)
							break
			for card in cards:
				card.movement_component.set_destination(CARD_SPEED, to_global(Vector3(0,0, y_offset)))
				y_offset += CARD_DISTNACE/10
		else:
			for card in cards:
				card.movement_component.set_destination(CARD_SPEED,to_global(Vector3(0,y_offset/10,y_offset)))
				y_offset += CARD_DISTNACE
