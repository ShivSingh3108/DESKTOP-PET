extends Node2D

var speed =170
var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200,200)
@onready var animated_sprite = $AnimatedSprite2D2
@onready var area = $Area2D
var is_dragging = false
var drag_offset = Vector2()
var idle_timer = 0.0
var is_idling = false
func maybe_idle():
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0,3.0)
		var r = randi() % 3
		if r == 0:
			animated_sprite.play("Idle")
			speed = 0
func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	animated_sprite.play("Walk_Right")
	area.input_event.connect(_on_area_input)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var window_position=Vector2(DisplayServer.window_get_position())
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 170
			animated_sprite.play("Walk_Right")
		return
	window_position += direction * speed * delta
	print(window_position)
	window_position.x =clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y =clamp(window_position.y, 0, screen_size.y - window_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	if window_position.x <=0 or window_position.x >= screen_size.x - window_size.x:
		direction.x *= -1
		animated_sprite.flip_h = !animated_sprite.flip_h
		maybe_idle()
	if window_position.y <=0 or window_position.y >= screen_size.y - window_size.y:
		direction.y *= -1
		maybe_idle()
	if is_dragging: 
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
		
	
	
func _on_area_input(_viewport, event,_shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true 
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			is_dragging = false
	
