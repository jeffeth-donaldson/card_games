extends Node3D

class_name Deck
var CardNode = preload("res://entities/card/Card.tscn")
var cards:Array[Card] = []
var model_changed: bool

func _init(deck:DeckModel = DeckModel.Standard52()):
	for card_model:CardModel in deck.cards:
		var newCard = CardNode.instantiate()
		newCard.card_model = card_model
		cards.append(newCard)
		add_child(newCard)
	
func reload_children():
	var z_offset = 0
	for card in self.cards:
		card.translate(Vector3(0, 0, z_offset))
		z_offset -= 0.01
	model_changed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	reload_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if model_changed:
		#print("redrawing deck")
		reload_children()

func draw(new_owner:Node3D, n=1)->Array[Card]:
	# Draw n cards (or the rest of the cards)
	# returns an array of the drawn cards
	var res:Array[Card]=[]
	if n > len(self.cards):
		n = len(self.cards)
	for i in range(n):
		var card = self.cards.pop_back()
		card.reparent(new_owner)
		res.append(card)
	return res
	
func cards_left()->int:
	return len(self.cards)
	
func shuffle():
	model_changed = true
	self.cards.shuffle()
