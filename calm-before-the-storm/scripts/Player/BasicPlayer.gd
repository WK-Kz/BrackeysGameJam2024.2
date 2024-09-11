extends CharacterBody2D 

var stamina : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#idle s-0 se-1 e-2 ne-3 n-4 nw-5 w-6 sw-7
@export var SPEED = 400
@export var ACCELERATION = 1000
@export var FRICTION = 5
@onready var animated_sprite = $AnimatedSprite2D
var is_walking = false
var last_cardinal = {'north': true, 'south': false, 'west': false, 'east': true}
var north = false
var south = false
var west = false
var east = false
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

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = self.velocity.move_toward(direction * SPEED * ACCELERATION, delta * ACCELERATION)
		is_walking = true
		last_cardinal.north = false;
		last_cardinal.west = false;
		last_cardinal.east = false;
		last_cardinal.south = false;
	else:
		self.velocity = Vector2.ZERO
		is_walking = false

	
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta_: float) -> void:
	process_walking()
	pass
func process_walking():

	if velocity.y > 0.5 or velocity.y < -0.5  or velocity.x > 0.5 or velocity.x < -0.5:
		east = false
		west = false
		north = false
		south = false

		
		if Input.is_action_pressed("ui_up"):
			north = true;
			
		elif Input.is_action_pressed("ui_down"):
			south = true;
			
		if Input.is_action_pressed("ui_left"):
			west = true;
			
		elif Input.is_action_pressed("ui_right"):
			east = true;
			
	else:
		if Input.is_action_just_released("ui_up"):
			north = true;
		elif Input.is_action_just_released("ui_down"):
			south = true;
		if Input.is_action_just_released("ui_left"):
			print('w')
			west = true;
		elif Input.is_action_just_released("ui_right"):
			print('e')
			east = true;
			
	if is_walking and (velocity.y > 50 or velocity.y < -50  or velocity.x > 50 or velocity.x < -50):
		print(velocity)
		print('passed')
		if north:
			if west:
				animated_sprite.play("walk_northwest")
				last_cardinal = { 
					'north':true,
					'west':true,
					'south':false,
					'east':false
				 }
			elif east:
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
		elif south:
			if west:
				animated_sprite.play("walk_southwest")
				last_cardinal = { 
					'north':false,
					'west':true,
					'south':true,
					'east':false
				 }
			elif east:
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
		elif west:
			animated_sprite.play("walk_west")
			last_cardinal = { 
					'north':false,
					'west':true,
					'south':false,
					'east':false
				 }
		elif east:
			animated_sprite.play("walk_east")
			last_cardinal = { 
					'north':false,
					'west':false,
					'south':false,
					'east':true
				 }
		print('walk')#play appropriate walk anim
	else:
		process_idle()
		print('idle')
		print(last_cardinal)
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
