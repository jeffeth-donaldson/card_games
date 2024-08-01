extends Node3D

class_name Hand

var cards:Array[Card] = []
var position_dict={}
var model_changed = false
var width:float
var center:float
var a:float # This is used for the parabola representing the curve of cards
var sort_function:Callable
var focused_card:int = -1 # Used for hovering a card, -1 is no card is focused
const MAX_CARD_DISTANCE=0.8
const CARD_SPEED=0.5
const MAX_HEIGHT=0.25
const FOCUSED_NEIGHBOR_SHUFFLE=0.25
const FOCUSED_MOVEMENT=0.33

static func default_sort(a:Card, b:Card):
	return a.card_model.card_num < b.card_model.card_num

func _init(new_width=10, new_sort_function:Callable=default_sort):
	self.sort_function = new_sort_function
	self.width = new_width
	self.center = width/2.0

# Functions for Determining Card Curve
func _calculate_a(start:float) -> float:
	# Here's the explanation for this math:
	# Parabola Vertex Form: f(x) = a(x-h)^2 +k, where (h,k) is the vertex
	# We want zeros at start and end
	# h = center
	# k = MAX_HEIGHT
	# 0 = a(start-center)^2 + MAX_HEIGHT
	# a = -MAX_HEIGHT/[(start-center)^2]
	return -MAX_HEIGHT/((start-center)**2)

func _get_card_height_on_curve(x:float) -> float:
	# Parabola Vertex Form: f(x) = a(x-h)^2 + k, where (h,k) is the vertex
	#print("x: ",x)
	return a*((x-center)**2)+MAX_HEIGHT

func add_cards(new_cards:Array[Card]):
	for card in new_cards:
		cards.append(card)
		card.reparent(self, true)
		card.hoverable_component.on_leave = func(point:Vector3): _unfocus_card()
	_update_hand_order()
	
func done_moving() -> bool:
	return cards.all(func(n:Card): return not n.movement_component.in_motion)
	
func _set_focused_card(card: int):
	if focused_card != card and done_moving():
		focused_card = card
		print("focused card:", card)
		_update_hand_order()
func _unfocus_card():
	print("unfocused")
	focused_card = -1
	_update_hand_order()
func _update_hand_order():
	if len(cards) > 0:
		cards.sort_custom(sort_function)
		var distance_between_cards = min(MAX_CARD_DISTANCE, width/len(cards))
		var starting_point = 0
		if distance_between_cards == MAX_CARD_DISTANCE:
			starting_point = center - (MAX_CARD_DISTANCE*len(cards)/2.0)
		a = _calculate_a(starting_point+cards[0].get_width())
		var heights:Array[float]=[]
		var half_the_cards = int(ceil(len(cards)/2.0))
		for i in range(half_the_cards):
			if len(cards) > 3:
				heights.append(
					_get_card_height_on_curve(starting_point+(i*distance_between_cards))
					)
			else:
				heights.append(0)
		var i = 0 # counter for height
		var j = 0 # counter for card focus
		for card in cards:
			# Need to reset in case order has changed.
			card.hoverable_component.on_hover = func(point:Vector3): _set_focused_card(j)
			if i >= half_the_cards:
				heights.reverse()
				i = len(cards)%2
			var card_x = starting_point
			var card_y = heights[i]
			#print(card_y)
			var card_z = starting_point*(0.1/len(cards))
			if focused_card > -1:
				if j == focused_card:
					card_z += FOCUSED_MOVEMENT
				elif j == focused_card -1:
					card_x -= FOCUSED_NEIGHBOR_SHUFFLE
				elif j == focused_card + 1:
					card_x += FOCUSED_NEIGHBOR_SHUFFLE
			card.movement_component.set_destination(
				CARD_SPEED, 
				to_global(Vector3(
					card_x,
					card_y,
					card_z
					))
				)
			starting_point += distance_between_cards
			i += 1
			j += 1
		#print("------------------")
		
func _physics_process(_delta):
	pass
