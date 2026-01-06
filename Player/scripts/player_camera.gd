class_name PlayerCamera extends Camera2D

# Lets the script run along the global autoload and integrates it.
func _ready():
	LevelManager.tilemap_bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_tilemap_bounds)
	pass

# Updates the limits of the camera according to the bounds of the level.
func update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	pass
