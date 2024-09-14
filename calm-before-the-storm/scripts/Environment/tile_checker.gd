extends Area2D
@onready var tileChecker = $"."
@onready var floorGroupLayers = get_tree().get_nodes_in_group("floor")
@onready var floorLayer;

var tileList = []
var onSpecialTile = false
 #Have to ignore the first/last tile
var curPos = Vector2i.ZERO
var lock = false
var prevPos : Vector2i
signal puzzle_exited(tiles)
signal puzzle_tile_activated(tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	tileChecker.connect("body_entered", on_Area2D_body_entered)
	tileChecker.connect("body_exited",on_Area2D_body_exited)

func on_Area2D_body_entered(body):
	floorLayer = body
	if floorLayer:
		#firstTile = floorLayer.local_to_map(self.global_position)
		onSpecialTile = true
	floorLayer.connect("puzzle_cleared",clearedPuzzle)
	floorLayer.connect("puzzle_failed", leaveSpecialTiles)
func on_Area2D_body_exited(body):

	var lastTile = floorLayer.local_to_map(self.global_position)
	if(floorLayer.get_cell_source_id(lastTile)== 24):
		onSpecialTile = false
		puzzle_exited.emit(tileList)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(floorLayer):
		curPos = floorLayer.local_to_map(self.global_position)
		if(curPos == Vector2i(0,0)):
			print(curPos)
			print(floorLayer.get_cell_source_id(curPos))
			if onSpecialTile:
				if !(floorLayer.get_cell_source_id(curPos)== 24):
					if(floorLayer.get_cell_source_id(curPos)== 0):
						print("bruh")
		if onSpecialTile && !lock:
			if !(floorLayer.get_cell_source_id(curPos)== 24):
				if(floorLayer.get_cell_source_id(curPos)== 0) && !tileList.has(curPos):
					tileList.append(curPos)
					floorLayer.set_cell(curPos,1,Vector2.ZERO,0)
					prevPos = curPos
				elif prevPos != curPos:
					leaveSpecialTiles()
		elif !onSpecialTile:
			lock = false

func leaveSpecialTiles():
	for tile in tileList:
		if(floorLayer.get_cell_source_id(tile)==1) && tileList.has(tile):
			floorLayer.set_cell(tile,2,Vector2.ZERO,0)
	lock = true
	await get_tree().create_timer(1.0).timeout
	for tile in tileList:
		if(floorLayer.get_cell_source_id(tile)==2) && tileList.has(tile):
			floorLayer.set_cell(tile,0,Vector2.ZERO,0)
	tileList.clear()

func clearedPuzzle():
	print("CONGRATS")
