extends CharacterBody2D 

var stamina : int = 100

@export var SPEED = 400
@export var ACCELERATION = 1000
@export var FRICTION = 5

# delta is not being used in calculation for velocity, we want the player to be moving at a constant speed all the time
# in addition, delta is automatically used within the move and slide code
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
