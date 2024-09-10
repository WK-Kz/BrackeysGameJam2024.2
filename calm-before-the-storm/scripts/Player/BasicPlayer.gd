extends CharacterBody2D 

var stamina : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var SPEED = 400
@export var ACCELERATION = 1000
@export var FRICTION = 5

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction:
		self.velocity = self.velocity.move_toward(direction * SPEED * ACCELERATION, delta * ACCELERATION)
	else:
		self.velocity = Vector2.ZERO

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta_: float) -> void:
	pass
