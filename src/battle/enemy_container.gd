class_name EnemyContainer
extends Node2D

var enemy_positions: Array[Vector2] = []
var enemy_count: int = 0

func set_enemy_positions(num_enemies: int):
	enemy_positions = get_enemy_positions(num_enemies)
	enemy_count = 0

func add_enemy(enemy: Enemy) -> bool:
	if enemy_count < enemy_positions.size():
		self.add_child(enemy)
		enemy.position = enemy_positions[enemy_count]
		enemy_count += 1
		print("Added enemy at position:", enemy.position)
		return true
	else:
		print("Cannot add enemy: maximum number reached.")
		return false

func get_enemy_positions(num_enemies: int) -> Array[Vector2]:
	# Choose formation based on the number of enemies
	if num_enemies == 1:
		return [Vector2(0, -100)]
	elif num_enemies == 2:
		return [Vector2(-150, -100), Vector2(150, -100)]
	elif num_enemies <= 4:
		return get_grid_positions(num_enemies, 2)
	else:
		return get_circle_positions(num_enemies)

func get_grid_positions(num_enemies: int, columns: int = 2) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var spacing_x = 150
	var spacing_y = 150
	var rows = ceil(num_enemies / columns)
	var start_x = -((columns - 1) * spacing_x) / 2
	var start_y = -((rows - 1) * spacing_y) / 2
	var index = 0
	for row in rows:
		for column in columns:
			if index >= num_enemies:
				break
			var position = Vector2(start_x + column * spacing_x, start_y + row * spacing_y)
			positions.append(position)
			index += 1
	return positions

func get_circle_positions(num_enemies: int) -> Array[Vector2]:
	var positions: Array[Vector2] = []
	var radius = 200
	var center = Vector2.ZERO
	for i in num_enemies:
		var angle = (PI * 2 / num_enemies) * i
		var position = center + Vector2(cos(angle), sin(angle)) * radius
		positions.append(position)
	return positions
