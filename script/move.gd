
extends Node2D

var speed =170
var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200,200)
@onready var animated_sprite = $AnimatedSprite2D2
@onready var area = $Area2D

var is_dragging = false
var drag_offset = Vector2()
var mouse = Vector2(DisplayServer.mouse_get_position())

var idle_timer = 0.0
var is_idling = false
var lines =["What ? ",
"U want to know about me ?",
"So I am Malware ","i came from threat dimension.",
" Unfortunately ","I am nothing like my name:(",
 "I left my place ","becuz i am useless . ",
"Everyone at my place is Dangerous ","and i am nothing like them .", 
"Then i came to this world"," all alone but then i met iris ,",
 "She helped me ","(No i am not BLUSHING 😳 )","and now i work as Desktop pet.",
"behhhh !!!! are you scared?",
"I guess am good as GOOD GUY"," with TUFF look. "]
var index =0
func start_talking():
	index = 0
	show_line()
	
func show_line():
	$Label2.text = lines[index]
	$Label2.show()
	$Timer2.start(3.0)
	
func _on_timer_2_timeout():
	index +=1
	if index >=lines.size():
		$Label2.hide()
		
		return
	show_line()	
func maybe_idle():
	if randf() < 0.6:
		is_idling = true
		idle_timer = randf_range(2.0,4.0)
		var r = randi() % 3
		if r <=1:
			animated_sprite.play("Idle")
			speed = 0
func _ready():
	$Label.visible = true
	get_viewport().transparent_bg= true
	get_tree().create_timer(3.0).timeout.connect(func():$Label.visible = false)
	screen_size = Vector2(DisplayServer.screen_get_size())
	animated_sprite.play("Walk_Right")
	area.input_event.connect(_on_area_input)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var window_position=Vector2(DisplayServer.window_get_position())
	$CPUParticles2D.restart()
	$CPUParticles2D.emitting=true
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
		$AnimatedSprite2D2.material.set_shader_parameter("flash",1.0)

		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
	
	
	
func _on_area_input(_viewport, event,_shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true 
			$AnimatedSprite2D2.material.set_shader_parameter("flash",1.0)
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			$AnimatedSprite2D2.material.set_shader_parameter("flash",0)

			is_dragging = false
			
func _input(event):if event is InputEventMouseButton and event.pressed: 
	if event.double_click:
		OS.shell_open("https://shivsingh3108.github.io/WebOS/")
	else:
		start_talking()
		

	
	
			
		
		
