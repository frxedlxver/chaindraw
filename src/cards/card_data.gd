class_name CardData extends Resource

enum TargetType {
	PLAYER,
	ALL_ENEMIES,
	SINGLE_ENEMY
}

@export var title: String
@export var description: String
@export var cost: int
@export var faceTex: Texture
@export var target_type : TargetType
@export var dealsDamage: bool = false
@export var givesBlock: bool = false
@export var inflictsEnemyStatus: bool = false
@export var inflictsPlayerStatus: bool = false
