class_name DeckSaveData extends Resource

@export var cards : Array[CardSaveData]

func extract_data_from_deck(deck_node : Deck):
	for card : CardNode in deck_node.cards.values():
		var card_save_data = CardSaveData.new()
		card_save_data.extract_data_from_cardbase(card.card_base)
		cards.append(card_save_data)
