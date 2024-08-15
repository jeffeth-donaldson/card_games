extends Node3D


var players:Array[HFPlayer]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _mytheme = CardThemeModel.new(
		"Test Theme",
		"res://assets/Cards Pack/PNG/Large/Back Blue 1.png",
		"res://assets/Cards Pack/PNG/Large/"
	)
	players = []
	for i in range(4):
		players.append(new HFPlayer)

	myHand = Hand.new()
	myHand.translate(Vector3(-4,-3,-3))
	myDeck = Deck.new()
	myDeck.translate(Vector3(1,0,0))
	myDeck.rotate_x(90)
	myDeck.shuffle()
	add_child(myDeck)
	add_child(myHand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
