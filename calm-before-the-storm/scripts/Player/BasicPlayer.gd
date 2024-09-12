extends CharacterBody2D 

var stamina : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area: Area2D = $PlayerDirection/InteractionArea

@export var SPEED =  400
@export var ACCELERATION = 1000
@export var FRICTION = 100

var is_walking = false
var last_cardinal = {'north': true, 'south': false, 'west': false, 'east': true}
var current_cardinal = {'north': false, 'south': false, 'west': false, 'east': true}
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

#region CharacterBody2D 
func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = self.velocity.move_toward(direction * SPEED * ACCELERATION , delta *ACCELERATION )
		is_walking = true
		last_cardinal = {'north': false, 'south': false, 'west': false, 'east': false}
		process_walking()
	else:
		self.velocity = Vector2.ZERO
		is_walking = false
		process_idle()
	
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta_: float) -> void:
	
	pass
#endregion

#region Input Movements
func process_walking():

	if velocity.y > 0.5 or velocity.y < -0.5  or velocity.x > 0.5 or velocity.x < -0.5:
		current_cardinal = {'north': false, 'south': false, 'west': false, 'east': false}
		
		if velocity.y < 0:
			current_cardinal.north = true;
		elif velocity.y > 0:
			current_cardinal.south = true;
		if velocity.x < 0:
			current_cardinal.west = true;
		elif velocity.x > 0:
			current_cardinal.east = true;
	else: #catch at stop just in case
		current_cardinal = {'north': false, 'south': false, 'west': false, 'east': true}
		if Input.is_action_just_released("ui_up"):
			current_cardinal.north = true;
		elif Input.is_action_just_released("ui_down"):
			current_cardinal.south = true;
		if Input.is_action_just_released("ui_left"):
			current_cardinal.west = true;
		elif Input.is_action_just_released("ui_right"):
			current_cardinal.east = true;
			
	if is_walking and (velocity.y > 50 or velocity.y < -50  or velocity.x > 50 or velocity.x < -50):
		if current_cardinal.north:
			if current_cardinal.west:
				animated_sprite.play("walk_northwest")
				last_cardinal = { 
					'north':true,
					'west':true,
					'south':false,
					'east':false
				 }
			elif current_cardinal.east:
				animated_sprite.play("walk_northeast")
				last_cardinal = { 
					'north':true,
					'west':false,
					'south':false,
					'east':true
				 }
			else:
				animated_sprite.play("walk_north")
				last_cardinal = { 
					'north':true,
					'west':false,
					'south':false,
					'east':false
				 }
		elif current_cardinal.south:
			if current_cardinal.west:
				animated_sprite.play("walk_southwest")
				last_cardinal = { 
					'north':false,
					'west':true,
					'south':true,
					'east':false
				 }
			elif current_cardinal.east:
				animated_sprite.play("walk_southeast")
				last_cardinal = { 
					'north':false,
					'west':false,
					'south':true,
					'east':true
				 }
			else:
				animated_sprite.play("walk_south")
				last_cardinal = { 
					'north':false,
					'west':false,
					'south':true,
					'east':false
				 }
		elif current_cardinal.west:
			animated_sprite.play("walk_west")
			last_cardinal = { 
					'north':false,
					'west':true,
					'south':false,
					'east':false
				 }
		elif current_cardinal.east:
			animated_sprite.play("walk_east")
			last_cardinal = { 
					'north':false,
					'west':false,
					'south':false,
					'east':true
				 }#play appropriate walk anim
	else:
		process_idle()

func process_idle():
		if last_cardinal.north:
			if last_cardinal.west:
				animated_sprite.play("idle_northwest")
			elif last_cardinal.east:
				animated_sprite.play("idle_northeast")
			else:
				animated_sprite.play("idle_north")
		elif last_cardinal.south:
			if last_cardinal.west:
				animated_sprite.play("idle_southwest")
			elif last_cardinal.east:
				animated_sprite.play("idle_southeast")
			else:
				animated_sprite.play("idle_south")
		elif last_cardinal.west:
			animated_sprite.play("idle_west")
		elif last_cardinal.east:
			animated_sprite.play("idle_east")
#endregion
