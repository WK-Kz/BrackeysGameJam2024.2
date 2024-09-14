extends State

class_name EnemyChase

@export var move_speed := 75.0
@export var detection_distance := 200
@export var enemy: CharacterBody2D
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	print(player)
	
func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
	
	if direction.length() > detection_distance:
		Transitioned.emit(self, "EnemyIdle")
