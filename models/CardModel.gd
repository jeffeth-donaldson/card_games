class_name CardModel

enum Suits {CLUBS, DIAMONDS, HEARTS, SPADES}

var card_num: int
var theme: CardThemeModel

func _init(new_card_num:int, new_theme:CardThemeModel):
	self.card_num = new_card_num
	self.theme = new_theme

func get_suit():
	@warning_ignore("integer_division")
	var suit = card_num / 13
	match suit:
		0:
			return Suits.CLUBS
		1:
			return Suits.DIAMONDS
		2:
			return Suits.HEARTS
		3:
			return Suits.SPADES
		4:
			return null

func get_value():
	# Is Joker
	if card_num > 51:
		return 14
	else:
		return card_num % 13 + 1
