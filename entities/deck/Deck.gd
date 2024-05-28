extends Node3D

class_name Deck
var CardNode = preload("res://entities/card/Card.tscn")
var deck: DeckModel
var model_changed: bool
func _init(deck:DeckModel = DeckModel.Standard52()):
	self.deck = deck
	
func reload_children():
	for child in get_children():
		remove_child(child)
	var z_offset = 0
	for card in self.deck.cards:
		var new_card = CardNode.instantiate()
		new_card.card_model = card
		new_card.translate(Vector3(0, 0, z_offset))
		self.add_child(new_card)
		z_offset -= 0.01
	model_changed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	reload_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if model_changed:
		#print("redrawing deck")
		reload_children()

func draw(n=1):
	model_changed = true
	return self.deck.draw(n)
	
func shuffle():
	model_changed = true
	self.deck.shuffle()
