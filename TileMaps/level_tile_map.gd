class_name LevelTileMap extends TileMapLayer

func _ready():
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())
	pass

# Gets the bounds for the tilemap acoording to the level size and the quadrant size (32 px).
func get_tilemap_bounds() -> Array[Vector2]:
	var bounds: Array[Vector2] = []
	bounds.append(Vector2(get_used_rect().position * rendering_quadrant_size))
	bounds.append(Vector2(get_used_rect().end * rendering_quadrant_size))
	return bounds
