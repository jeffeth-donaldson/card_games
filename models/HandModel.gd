extends Node

class_name HandModel

var cards:= []
var sortFunction:Callable

static func default_sort(a:CardModel, b:CardModel):
	return a.card_num < b.card_num

func _init(sortFunction:Callable=default_sort):
	self.sortFunction = sortFunction
	
func sort():
	cards.sort_custom(sortFunction)
	
func add_card(card:CardModel):
	cards.append(card)
	self.sort()

func pop_card(i:int):
	return cards.pop_at(i)
