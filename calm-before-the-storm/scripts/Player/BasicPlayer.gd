extends CharacterBody2D 

var stamina : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# TODO Change interaction_area with player direction
@onready var interaction_area: Area2D = $PlayerDirection/InteractionArea
@onready var animation_tree: AnimationTree = $AnimationTree

@export var SPEED =  200
var DIRECTION: Vector2 = Vector2.ZERO

var is_walking = false
var can_player_move : bool = true

func _ready() -> void:
	assert(animation_tree)
	animation_tree.active = true
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

#region CharacterBody2D 
func _physics_process(delta: float) -> void:
	if !can_player_move:
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = self.velocity.move_toward(direction * SPEED * ACCELERATION , delta *ACCELERATION )
		is_walking = true
		last_cardinal = {'north': false, 'south': false, 'west': false, 'east': false}
		process_walking()
	else:
		velocity = Vector2.ZERO
		
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/Idle/blend_position"] = DIRECTION
		animation_tree["parameters/Walk/blend_position"] = DIRECTION
		move_and_slide()
	
