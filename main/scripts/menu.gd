extends Control
@onready var lucy: AnimatedSprite2D = $"Lucy/Lucy + Title"
@onready var anim: AnimationPlayer = $anim

var iniciando_jogo = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_game_btn_pressed() -> void:
	
	if iniciando_jogo:
		return

	iniciando_jogo = true

	lucy.play("dormindo")   
	anim.play("fade_out")


func _on_quit_btn_pressed() -> void:
	lucy.play("quit")
	anim.play("fade_out")


func _on_js_coutinho_pressed() -> void:
	OS.shell_open("https://github.com/jscoutinho")


func _on_lucy__title_animation_finished() -> void:
	if lucy.animation == "dormindo":

		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	if lucy.animation == "quit":
		get_tree().quit()
