extends CanvasLayer

@onready var panel = $Panel
@onready var conteudo = $Panel/Conteudo
@onready var nome: Label = $Panel/Nome
@onready var imagem: TextureRect = $TextureRect


signal finished
var index := 0
var active := false
var texts: Array = []

func show_dialogue(dialogue: Array, sujeito: String, caminho: String):
	texts = dialogue
	index = 0
	active = true
	var texto = texts[index]

	conteudo.text = texto
	nome.text = sujeito
	imagem.texture = load(caminho)


	show()

	var player = get_tree().get_first_node_in_group("Player")
	player.go_to_dialogue_state()


func _ready():
	hide()

func _process(_delta):

	if !active:
		return

	if Input.is_action_just_pressed("ui_accept"):

		index += 1

		if index >= texts.size():
			hide()
			active = false
			var player = get_tree().get_first_node_in_group("Player")
			player.exit_dialogue()
			finished.emit()
		else:
			conteudo.text = texts[index]
