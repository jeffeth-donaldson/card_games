extends Node3D

var CardNode = preload("res://entities/card/Card.tscn")

var cards:= []
const ROTATION_SPEED = 1
var myDeck:Deck
var myHand:Hand
var elapsed_time = 0
var timer = 0
var cards_to_draw:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var _mytheme = CardThemeModel.new(
		"Test Theme",
		"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
		"res://assets/Cards Pack/PNG/Large/"
	)
	#var myCardModel = CardModel.new(5, mytheme)
	#var myCard = CardNode.instantiate()
	#myCard.card_model = myCardModel
	#add_child(myCard)
	#cards.append(myCard)

	new_deck()

func new_deck():
	myHand = Hand.new()
	myHand.translate(Vector3(-4,-3,-3))
	myDeck = Deck.new(DeckModel.HandAndFoot())
	myDeck.translate(Vector3(-4,-3,-3))
	myDeck.rotate_x(90)
	myDeck.shuffle()
	add_child(myDeck)
	add_child(myHand)

func _physics_process(delta):
	#for card in cards:
		#card.rotate_y(delta*ROTATION_SPEED)
	#elapsed_time += delta
	#if elapsed_time > 1.5 && myHand.done_moving():
		#myHand.add_cards(myDeck.draw(myHand))
		#elapsed_time = 0
	if myDeck.cards_left() < 1:
		myHand.queue_free()
		myDeck.queue_free()
		new_deck()
	#timer -= delta
	#if timer <= 0:
		#var randX = randf_range(-3,3)
		#var randY = randf_range(-3,3)
		#var randZ = randf_range(-3,3)
		#timer = 3
		#cards[0].movement_component.set_destination(timer, Vector3(randX,randY,randZ))


func _on_draw_card_button_pressed():
	myHand.add_cards(myDeck.draw(myHand, cards_to_draw))


func _on_card_draw_num_spin_box_value_changed(value):
	if value < 0:
		value = 0
	cards_to_draw = value
