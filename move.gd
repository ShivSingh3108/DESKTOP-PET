extends Node2D

var speed =300
var direction = Vector2(1,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var window_position=Vector2(DisplayServer.window_get_position())
	window_position += direction * speed * delta
	print(window_position)
	DisplayServer.window_set_position(Vector2i(window_position))

	
