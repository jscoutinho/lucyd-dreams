extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var harpa: AudioStreamPlayer2D = $Harpa

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Lucy_fora" and GameManager.poderes == 0:
		anim.play("atencao")
		harpa.play()
		var dialogue = get_tree().current_scene.get_node("UI/DialogueBox")
		
		var conversa = [
		{
			"sujeito": "???",
			"texto": "Não vi você aí. Está tudo bem?"
		}
		]
		dialogue.show_conversation(conversa)
		MusicManager.tocar_musica(load("res://assets/msc/ella.mp3"))
		
		GameManager.poderes = 1; 



func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "atencao":
		anim.play("idle")
