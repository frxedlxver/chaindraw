class_name DebugDeckLoader



static func get_deck() -> Deck:
	var deck = Deck.new()
	
	
	var attack_data_dict = {
		"id" : 0,
		"logic_script_path" : "res://cards/card_data/Attack.gd",
		"bonded_to" : -1,
		"metadata": {}
	}
	var defend = {
		"id" : 0,
		"logic_script_path" : "res://cards/card_data/Feint.gd",
		"bonded_to" : -1,
		"metadata": {}
	}

	
	for i in range(10):
		var first_card = CardFactory.load_card_from_save_data(attack_data_dict)
		deck.add_card(first_card)
		var next_card = CardFactory.load_card_from_save_data(defend)
		next_card.card_base.next_in_chain = first_card.card_base.id;
		deck.add_card(next_card)
		
		
	


	print("deck size %s" % deck.card_count())
	return deck;
