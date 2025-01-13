class_name DebugDeckLoader



static func get_deck() -> Deck:
	var deck = Deck.new()
	
	
	var attack = CardSaveData.new()
	var defend = CardSaveData.new()
	attack.id = 0
	attack.logic_script_path = "res://assets/cards/card_data/Attack.gd"
	defend.id = 0
	defend.logic_script_path = "res://assets/cards/card_data/Bide.gd"
	print(OS.get_user_data_dir())
	
	for i in range(10):
		attack.id = CardFactory.get_next_card_id()
		var first_card = CardSaveDataHandler.load_card_from_save_data(attack)
		deck.add_card(first_card)
		defend.id = CardFactory.get_next_card_id()
		var next_card = CardSaveDataHandler.load_card_from_save_data(defend)
		deck.add_card(next_card)
		
		
	


	print("deck size %s" % deck.card_count())
	return deck;
