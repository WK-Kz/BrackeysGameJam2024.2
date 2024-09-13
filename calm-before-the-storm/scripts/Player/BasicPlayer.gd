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
enum AVAILABLE_ACTIONS
{
	WALK,
	INTERACT
}

enum INTERACT_OPTIONS
{
	TALK,
	MOVE_BOX,
	PRESS_BUTTON,
	SWITCH_LEVER
}

func _ready() -> void:
	assert(animation_tree)
	animation_tree.active = true

func _physics_process(_delta: float) -> void:
	DIRECTION = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	if DIRECTION:
		velocity = DIRECTION * SPEED
	else:
		velocity = Vector2.ZERO
		
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		#animation_tree.get("parameters/playback").travel("Idle")
		
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		#animation_tree.get("parameters/playback").travel("Walk")
		animation_tree["parameters/Idle/blend_position"] = DIRECTION
		animation_tree["parameters/Walk/blend_position"] = DIRECTION
		move_and_slide()
	
