class_name CardModel

enum Suits {CLUBS, DIAMONDS, HEARTS, SPADES}

var card_num: int
var theme: CardThemeModel

func get_suit():
	match card_num / 13:
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
