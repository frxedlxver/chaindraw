class_name DebugDeckLoader

static var path : String = "user://deck.res"
static var deck : Deck

static func get_deck() -> Deck:
	if deck == null:
		deck = Deck.new()
	
	for i in range(10):
		deck.add_card(CardFactory.create_card(Attack))
		deck.add_card(CardFactory.create_card(Block))
	print("deck size %s" % deck.card_count())
	return deck;
