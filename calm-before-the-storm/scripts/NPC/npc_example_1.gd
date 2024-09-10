extends CharacterBody2D

signal interact

@export var speed : int = 1500
@export var wait_time: int = 3

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@onready var can_walk : bool = false

enum State
{
	IDLE,
	WALK_NORTH,
	WALK_NORTHEAST,
	WALK_EAST,
	WALK_SOUTHEAST,
	WALK_SOUTH,
	WALK_SOUTHWEST,
	WALK_WEST,
	WALK_NORTHWEST
}

var ANIMATION_STATES : Dictionary = \
{
	State.IDLE : "idle",
	State.WALK_NORTH : "walk_north",
	State.WALK_NORTHEAST : "walk_northeast",
	State.WALK_EAST : "walk_east",
	State.WALK_SOUTHEAST : "walk_southeast",
	State.WALK_SOUTH : "walk_south",
	State.WALK_SOUTHWEST : "walk_southwest",
	State.WALK_WEST : "walk_west",
	State.WALK_NORTHWEST : "walk_northwest"
}

var rng = RandomNumberGenerator.new()
@onready var current_state : State = State.IDLE
var npc_dialogue = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var npc_dialogue = load("res://scenes/NPC/Dialogues/balloon.gd").instantiate()
	timer.wait_time = wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta_: float) -> void:
	if !can_walk:
		choose_animation()

func _on_timer_timeout() -> void:
	can_walk = true

func choose_animation() -> void:
	var next_state = current_state
	var next_animation = null

	while current_state == next_state:
		var rng_state = rng.randi_range(0, ANIMATION_STATES.size())
		current_state = ANIMATION_STATES.keys()[rng_state]
		next_animation = ANIMATION_STATES[current_state]
	
	animated_sprite_2d.play(next_animation)


func _on_interact() -> void:
	# Perform dialogue
	get_tree().current_scene.add_child(npc_dialogue)
	npc_dialogue.start()
