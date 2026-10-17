extends CanvasLayer
# Called when the node enters the scene tree for the first time.
@onready var corda_e: Sprite2D = $Control/CordaE
@onready var corda_a: Sprite2D = $Control/CordaA
@onready var corda_d: Sprite2D = $Control/CordaD
@onready var corda_g: Sprite2D = $Control/CordaG

@onready var e: AudioStreamPlayer = $E
@onready var a: AudioStreamPlayer = $A
@onready var d: AudioStreamPlayer = $D
@onready var g: AudioStreamPlayer = $G



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		
func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_esc_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file",("res://scenes/maps/menu.tscn"))


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_continue_mouse_entered() -> void:
	corda_e.vibrar()
	e.play()


func _on_config_mouse_entered() -> void:
	corda_a.vibrar()
	a.play()

func _on_esc_to_menu_mouse_entered() -> void:
	corda_d.vibrar()
	d.play()

func _on_exit_mouse_entered() -> void:
	corda_g.vibrar()
	g.play()
