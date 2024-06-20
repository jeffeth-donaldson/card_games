extends Node

class_name DeckModel
# Class representing a deck of cards
# For the sake of performance, element 0 of the array represents the last card in the deck
# The first card in the deck is element len(array)-1
static var default_theme = CardThemeModel.new(
		"default",
		"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
		"res://assets/Cards Pack/PNG/Large/"
)
# Members
var cards:Array[CardModel]= []

func _init(cards:Array[CardModel]):
	self.cards = cards
	

func cards_left():
	# Returns number of cards left in deck
	return len(self.cards)

func shuffle():
	# Shuffles order of cards
	self.cards.shuffle()

func draw(n=1) -> Array[CardModel]:
	# Draw n cards (or the rest of the cards)
	# returns an array of the drawn cards
	var res:Array[CardModel]=[]
	if n > self.cards_left():
		n = self.cards_left()
	for i in range(n):
		res.append(self.cards.pop_back())
	return res

func add(other:DeckModel):
	# Adds another deck model to this deck, with this deck on bottom
	self.cards.append_array(other.cards)

# Factory methods
static func Standard52(theme:CardThemeModel=default_theme):
	var cards:Array[CardModel] = []
	for i in range(53):
		cards.append(CardModel.new(i, theme))
	return DeckModel.new(cards)
