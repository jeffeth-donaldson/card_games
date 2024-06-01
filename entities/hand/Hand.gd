extends Node3D

class_name Hand

var cards = []
var position_dict={}
var model_changed = false
var width:int
var sort_function:Callable

func _init(width=get_viewport().get_visible_rect().size.x, sort_function:Callable=HandModel.default_sort):
	self.sort_function = sort_function
	self.width = width
	

func add_card(card:Card):
	cards.append(card)
	add_child(card)
	
func _update_hand_order():
	cards.sort_custom(sort_function)
	for card in cards:
		# TODO: go through and figure out position based on length of card array
		# TODO: figure out rotational speed
		# TODO: find out how fast the card should be moving
		# TODO: set card acceleration
		# TODO: Should probably create some kind of motion plan object and use composition instead
		pass
		
func _physics_process(delta):
	# TODO: Move/rotate cards according to what we specified previously
	pass
