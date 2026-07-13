extends Control
var slides = [
	{
		"imagem": preload("res://assets/intro/img-1.png"),
		"texto": "Eu não deveria ter feito uma coisa tão estúpida assim. Eu sei do que eu sou capaz, e isso estava além da minha capacidade"
	},
	{
		"imagem": preload("res://assets/intro/img-2.png"),
		"texto": "Eu só queria sentir de novo o que eu senti naquele dia. Mas não tem como trazer aquele momento de volta"
	},
	{
		"imagem": preload("res://assets/intro/img-3.png"),
		"texto": "Ela me deu tanta coisa, eu deveria ter agradecido mais, feito mais. Ou pelo menos ter acertado a parte favorita dela"
	},
	{
		"imagem": preload("res://assets/intro/img-4.png"),
		"texto": "Eu nunca vou ser tão talentosa, alegre, especial e incrível como você foi. Me desculpe, eu falhei"
	}
]

var slide_atual = 0

func mostrar_slide():

	$TextureRect.texture = slides[slide_atual]["imagem"]

	$Label.text = slides[slide_atual]["texto"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mostrar_slide()

	$AnimationPlayer.play("fade_in")

func _input(event):

	if event.is_action_pressed("ui_accept"):

		$AnimationPlayer.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":

		slide_atual += 1

		if slide_atual >= slides.size():

			get_tree().change_scene_to_file("res://scenes/casa.tscn")
			return

		mostrar_slide()

		$AnimationPlayer.play("fade_in")
