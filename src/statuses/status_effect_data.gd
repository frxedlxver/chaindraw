class_name StatusEffectData extends Resource

enum StatusType {
	BUFF,
	DEBUFF
}

@export var name: String
@export var type : StatusType
@export var icon : CompressedTexture2D
