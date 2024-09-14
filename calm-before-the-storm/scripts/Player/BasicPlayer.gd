extends CharacterBody2D 

var stamina : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interaction_area: Area2D = $PlayerDirection/InteractionArea
@onready var animation_tree: AnimationTree = $AnimationTree

@export var SPEED =  200
var direction: Vector2 = Vector2.ZERO


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
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	elif (can_player_move):
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		move_and_slide()
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var interactions : Array[Area2D] = interaction_area.get_overlapping_areas()
		if interactions.size() > 0:
			var resulting_action = interactions[0].interact()
			if resulting_action == PlayerBehavior.INTERACTIONS.TALK:
				can_player_move = false

# Dialogue Handler for the DialaogueManager to indicate end of talk with NPC/Interaction
func _on_dialogue_ended(_resource: DialogueResource):
	can_player_move = true
