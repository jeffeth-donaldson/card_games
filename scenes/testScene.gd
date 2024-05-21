extends Node3D

var CardNode = preload("res://entities/card/Card.tscn")

var cards:= []
const ROTATION_SPEED = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	var mytheme = CardThemeModel.new(
		"Test Theme",
		"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
		"res://assets/Cards Pack/PNG/Large/"
	)
	var myCardModel = CardModel.new()
	myCardModel.card_num = 5
	myCardModel.theme = mytheme
	var myCard = CardNode.instantiate()
	myCard.card_model = myCardModel
	add_child(myCard)
	cards.append(myCard)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for card in cards:
		card.rotate_x(delta*ROTATION_SPEED)
