extends Area2D
@onready var tileChecker = $"."
@onready var floorGroupLayers = get_tree().get_nodes_in_group("floor")
@onready var floorLayer;

var tileList = []
var onSpecialTile = false
var lock = false
var firstTile = Vector2i.ZERO #Have to ignore the first/last tile
var lastTile = Vector2i.ZERO
var curPos = Vector2i.ZERO
var prevPos
# Called when the node enters the scene tree for the first time.
func _ready():
	#Get first(only one in this case) from list of nodes in group
	if floorGroupLayers.size() > 0:
		print_debug("INFO: Floor Tiles found")
		floorLayer = floorGroupLayers[0]
	else:
		print_debug("WARN: No floor tile layer found")
	tileChecker.connect("body_entered", on_Area2D_body_entered)
	tileChecker.connect("body_exited",on_Area2D_body_exited)
	#print(tileDetector)
	pass # Replace with function body.

func on_Area2D_body_entered(body):
	if floorLayer:
		#var tile_position = floorLayer.world_to_map(body.global_position)
		firstTile = floorLayer.local_to_map(self.global_position)
		
		print(floorLayer.get_cell_source_id(curPos))
		print(firstTile)
		onSpecialTile = true
		print(floorLayer.local_to_map(self.global_position))
	print("Entered body:", body.name)
func on_Area2D_body_exited(body):

	lastTile = floorLayer.local_to_map(self.global_position)
	if(floorLayer.get_cell_source_id(lastTile)== 24):
		onSpecialTile = false
		self.leaveSpecialTiles()
	print(floorLayer.local_to_map(self.global_position))
	print(tileList)
	print("Exited body:", body.name)
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
				print(tileList)
				print(onSpecialTile)
		if onSpecialTile && !lock:
			if !(floorLayer.get_cell_source_id(curPos)== 24):
				if(floorLayer.get_cell_source_id(curPos)== 0) && !tileList.has(curPos):
					tileList.append(curPos)
					print("Activating: ",curPos)
					print("CurrTileSource:", floorLayer.get_cell_source_id(curPos))
					floorLayer.set_cell(curPos,1,Vector2.ZERO,0)
			

func leaveSpecialTiles():
	if floorLayer.get_cell_source_id(curPos)== 24:
				print(tileList)
				for tile in tileList:
					if(floorLayer.get_cell_source_id(tile)==1) && tileList.has(tile):
						floorLayer.set_cell(tile,2,Vector2.ZERO,0)
				await get_tree().create_timer(1.0).timeout
				for tile in tileList:
					if(floorLayer.get_cell_source_id(tile)==2) && tileList.has(tile):
						floorLayer.set_cell(tile,0,Vector2.ZERO,0)
				tileList.clear()
				print(tileList)
	#var overlapping_bodies = get_overlapping_bodies()
	#for body in overlapping_bodies:
	#	print(body.name)
	pass
