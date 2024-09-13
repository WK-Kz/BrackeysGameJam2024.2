extends Sprite2D

@onready var _silhouette_sprite: Sprite2D = $SilhouetteSprite

func _ready() -> void:
	assert(_silhouette_sprite)

func _process(_delta: float) -> void:
	_set_silhouette()

func _set_silhouette() -> void:
	_silhouette_sprite.texture = texture
	_silhouette_sprite.offset = offset
	_silhouette_sprite.flip_h = flip_h
	_silhouette_sprite.hframes = hframes
	_silhouette_sprite.vframes = vframes
	_silhouette_sprite.frame = frame
	

func _set(property: StringName, value: Variant) -> bool:
	if is_instance_valid(_silhouette_sprite):
		match property:
			"texture":
				_silhouette_sprite.texture = value
				return true
			"offset":
				_silhouette_sprite.offset = value
				return true
			"flip_h":
				_silhouette_sprite.flip_h = value
				return true
			"hframes":
				_silhouette_sprite.hframes = value
				return true
			"vframes":
				_silhouette_sprite.vframes = value
				return true
			"frame":
				_silhouette_sprite.frame = value
				return true
	return false
