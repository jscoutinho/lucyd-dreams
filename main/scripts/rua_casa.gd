extends Node2D
@onready var sino: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_altura_body_entered(body: Node2D) -> void:
	if GameManager.medoaltura == 0 :
		sino.play()
		var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")
		dialogue.show_dialogue(["Parece que o som vem do outro lado do abismo...", "Parece um bom dia para superar o medo de altura."], "Lucy")
		GameManager.medoaltura = 1; 
