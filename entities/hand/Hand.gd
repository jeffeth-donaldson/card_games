extends Node3D

class_name Hand

var cards:Array[Card] = []
var position_dict={}
var model_changed = false
var width:float
var center:float
var sort_function:Callable
const MAX_CARD_DISTANCE=0.8
const CARD_SPEED=1

static func default_sort(a:Card, b:Card):
	return a.card_model.card_num < b.card_model.card_num

func _init(new_width=10, new_sort_function:Callable=default_sort):
	self.sort_function = new_sort_function
	self.width = new_width
	self.center = width/2.0

func add_cards(new_cards:Array[Card]):
	for card in new_cards:
		cards.append(card)
		card.reparent(self, true)
	_update_hand_order()
	
func done_moving() -> bool:
	return cards.all(func(n:Card): return not n.movement_component.in_motion)
	
func _update_hand_order():
	cards.sort_custom(sort_function)
	var distance_between_cards = min(MAX_CARD_DISTANCE, width/len(cards))
	var starting_point = 0
	if distance_between_cards == MAX_CARD_DISTANCE:
		starting_point = center - (MAX_CARD_DISTANCE*len(cards)/2.0)
	for card in cards:
		card.movement_component.set_destination(0.5, to_global(Vector3(starting_point, 0,starting_point*(0.1/len(cards)))))
		starting_point += distance_between_cards
		
func _physics_process(_delta):
	pass
