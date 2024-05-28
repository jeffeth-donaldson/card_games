extends Node3D

var CardNode = preload("res://entities/card/Card.tscn")

var cards:= []
const ROTATION_SPEED = 1
var myDeck:Deck
var elapsed_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var mytheme = CardThemeModel.new(
		"Test Theme",
		"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
		"res://assets/Cards Pack/PNG/Large/"
	)
	var myCardModel = CardModel.new(5, mytheme)
	var myCard = CardNode.instantiate()
	myCard.card_model = myCardModel
	add_child(myCard)
	cards.append(myCard)
	
	new_deck()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func new_deck():
	myDeck = Deck.new()
	myDeck.translate(Vector3(1,0,0))
	myDeck.shuffle()
	add_child(myDeck)
	
func _physics_process(delta):
	for card in cards:
		card.rotate_y(delta*ROTATION_SPEED)
	elapsed_time += delta
	if elapsed_time > 0.25:
		myDeck.draw(1)
		elapsed_time = 0
	if myDeck.deck.cards_left() < 1:
		myDeck.queue_free()
		new_deck()
