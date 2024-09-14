extends TileMapLayer
@onready var currentLayer = $"."
@onready var tileChecker = $"../../MainPlayer"

var solution = []
# Called when the node enters the scene tree for the first time.
signal puzzle_cleared
signal puzzle_failed

func _ready():
	self.tileChecker = self.tileChecker.get_node("CharacterBody2D/TileChecker")
	self.tileChecker.connect("puzzle_exited", on_custom_signal)
	print("connected")
	pass # Replace with function body.
func connectSignals():
	self.tileChecker = self.tileChecker.get_node("CharacterBody2D/TileChecker")
	self.tileChecker.connect("puzzle_exited", on_custom_signal)
func on_custom_signal(value):
	var isEqual = true
	print("Solution:", solution)
	for i in value:
		var isFound = false
		for j in solution:
			if(i==j):
				isFound = true
				break
		if !isFound:
			isEqual = false
	if isEqual:
		self.puzzle_cleared.emit()
	else:
		self.puzzle_failed.emit()
	print(value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
