
extends Node2D

var speed =150
var direction = Vector2(1,0)
var screen_size = Vector2()
var window_size = Vector2(200,200)
@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D

var is_dragging = false
var drag_offset = Vector2()
var mouse = Vector2(DisplayServer.mouse_get_position())

var idle_timer = 0.0
var is_idling = false
var lines =["HI!! FIREWALL HERE",
"U want to know about me ?",
"So i from Guard dimension.",
"I was a soldier there",
 "But I had no powers unlike others",
"I still gave me 100% and thanks to my dedication", 
"Colonel Anti.V didn't fired me ","instead he sent me to this world",
 "He believes in me","and now i work as Senior commander Desktop pet.",
"and teach ppl about cybersafety",
]
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
var info = [
  "Phishing: Fake emails or messages trying to steal passwords or bank details.",
  "Never share OTPs, PINs, or passwords with anyone, even bank staff.",
  "Ransomware: Malware that locks your files and demands payment to unlock them.",
  "Always check website URLs carefully to avoid fake phishing sites.",
  "Malware: Any malicious software designed to harm or access your device.",
  "Use strong, unique passwords with letters, numbers, and symbols.",
  "Enable 2-Factor Authentication (2FA) on all your accounts for safety.",
  "Spyware: Hidden software that secretly tracks your activity and keystrokes.",
  "Never click on suspicious links sent via SMS, WhatsApp, or unknown emails.",
  "Trojan: Harmful code disguised as safe, legitimate software.",
  "Keep your apps and operating system updated to fix security bugs.",
  "Avoid using public Wi-Fi for sensitive transactions or online banking.",
  "Social Engineering: Manipulating people into revealing confidential info.",
  "Always backup your important files to an external drive or cloud storage.",
  "Identity Theft: Someone illegally using your personal details as their own.",
  "Check app permissions before installing to avoid granting unnecessary access.",
  "Firewall: A network security system that blocks unauthorized access.",
  "Adware: Unwanted software that automatically displays ads on your device.",
  "Keylogger: A tool that secretly records everything you type, including passwords.",
  "DDoS Attack: Flooding a website with traffic to crash it and make it unavailable.",
  "Zero-Day Vulnerability: A newly discovered security flaw before a fix is released.",
  "Botnet: A network of infected devices controlled by hackers to launch attacks.",
  "Rootkit: Secret software giving attackers full control over your computer system.",
  "Vishing: Voice phishing scams where attackers trick you over phone calls.",
  "Smishing: Phishing scams conducted specifically through text messages (SMS).",
  "Man-in-the-Middle: Intercepting communication between two parties secretly.",
  "Shoulder Surfing: Looking over someone's shoulder to steal PINs or passwords.",
  "Data Breach: Unauthorized access and leaking of sensitive corporate or user data.",
  "Biometric Auth: Using fingerprints or face recognition to secure your accounts.",
  "VPN: Encrypts your internet connection to protect privacy on public networks.",
  "Juice Jacking: Malware attacks carried out through public USB charging ports.",
  "Credential Stuffing: Using leaked passwords to breach other online accounts.",
  "Cryptojacking: Secretly using your computer's power to mine cryptocurrency."
];
func say_line():
	$Label3.text = info.pick_random()
	$Timer3.start(7.0)
	$Label3.show()
func _on_timer_3_timeout():
		$Label3.hide()
func maybe_idle():
	if randf() < 0.6:
		is_idling = true
		say_line()
		
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
	
	$PopupMenu.add_item("Rest",0)
	$PopupMenu.add_item("Arise",1)
	$PopupMenu.id_pressed.connect(_on_menu_pressed)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var window_position=Vector2(DisplayServer.window_get_position())
	
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 150
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
			
func _input(event):if event is InputEventMouseButton and event.pressed: 
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.double_click:
			OS.shell_open("https://stardance.hackclub.com/projects/69847")
		else:
			start_talking()
	elif event.button_index == MOUSE_BUTTON_RIGHT:	
		$PopupMenu.popup_on_parent(Rect2i(Vector2i(event.position),Vector2i.ZERO))		
	
func _on_menu_pressed(id:int):
	if id==0:
		animated_sprite.play("Rest")	
		speed=0
	else:
		animated_sprite.play("Walk_Right")	
		speed=150
		
			
		
		
