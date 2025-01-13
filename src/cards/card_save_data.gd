class_name CardSaveData extends Resource

@export var id : int
@export var logic_script_path : String

func extract_data_from_cardbase(card_base : CardBase):
	self.id = card_base.id
	self.logic_script_path = card_base.get_script().resource_path
