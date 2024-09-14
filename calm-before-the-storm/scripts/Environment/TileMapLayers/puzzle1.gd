extends "res://assets/tilemaplayer/TilePuzzle.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.solution = [Vector2i(3, 6),Vector2i(3, 7), Vector2i(3, 8), Vector2i(3, 9), Vector2i(4, 9), Vector2i(4, 8), Vector2i(4, 7), Vector2i(4, 6)]
	self.connectSignals()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
