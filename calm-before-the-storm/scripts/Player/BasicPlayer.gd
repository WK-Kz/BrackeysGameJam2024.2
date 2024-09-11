extends CharacterBody2D 

var stamina : int = 100
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var interaction_area: Area2D = $PlayerDirection/InteractionArea

@export var SPEED = 400
@export var ACCELERATION = 1000
@export var FRICTION = 5

var can_player_move : bool = true

func _physics_process(delta: float) -> void:
	if !can_player_move:
		return
	else:
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction:
		self.velocity = self.velocity.move_toward(direction * SPEED * ACCELERATION, delta * ACCELERATION)
	else:
		self.velocity = Vector2.ZERO

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta_: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var interactions = interaction_area.get_overlapping_areas()
		if interactions.size() > 0:
			var resulting_action = interactions[0].interact()
			if (resulting_action == PlayerBehavior.INTERACTIONS.TALK):
				can_player_move = false
				
func _on_dialogue_ended(_resource: DialogueResource):
	can_player_move = true
	
