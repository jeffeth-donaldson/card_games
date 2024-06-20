extends Node3D

class_name Hand

var cards = []
var position_dict={}
var model_changed = false
var width:float
var center:float
var sort_function:Callable
const MAX_CARD_DISTANCE=5

func _init(width=10, sort_function:Callable=HandModel.default_sort):
	self.sort_function = sort_function
	self.width = width
	self.center = width/2

func add_cards(new_cards:Array[Card]):
	for card in new_cards:
		cards.append(card)
		add_child(card)
	_update_hand_order()
	
func _update_hand_order():
	cards.sort_custom(sort_function)
	var distance_between_cards = min(MAX_CARD_DISTANCE, width/len(cards))
	var starting_point = 0
	if distance_between_cards == MAX_CARD_DISTANCE:
		starting_point = center - (MAX_CARD_DISTANCE*len(cards)/2)
	for card in cards:
		card.movement_component.set_destination(1, to_global(Vector3(starting_point, 0,0)))
		starting_point += distance_between_cards
		
func _physics_process(delta):
	pass
