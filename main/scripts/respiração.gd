extends Node2D
@onready var bolinhas: Node2D = $CanvasLayer/Bolinhas
@onready var hit_position = $CanvasLayer/HitPosition
@onready var focus_overlay = $CanvasLayer/FocusOverlay
@onready var anim: AnimatedSprite2D = $CanvasLayer/HitPosition/AnimatedSprite2D
@onready var guia: Sprite2D = $CanvasLayer/guia
@onready var anim_lucy: AnimatedSprite2D = $CanvasLayer/Control/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var monstro_1: AnimatedSprite2D = $CanvasLayer/Control2/Control/monstro1
@onready var monstro_2: AnimatedSprite2D = $CanvasLayer/Control2/Control2/monstro2
@onready var luthier: AnimatedSprite2D = $CanvasLayer/Control2/LuthierBox/AnimatedSprite2D
@onready var DialogueBox: CanvasLayer = $CanvasLayer/DialogueBox

#Variáveis do FOCO
var foco_atual := 0.18
const FOCO_MINIMO := 0.18
const FOCO_MAXIMO := 0.75
const FOCO_POR_ACERTO := 0.04

#Variáveis de Intervalo entre notas
var intervalo_spawn := 1.0

const INTERVALO_MINIMO := 0.6
const INTERVALO_MAXIMO := 1.5
const INTERVALO_POR_ACERTO := 0.1

#Variáveis das Notas
var respiration_note = preload("res://scenes/entities/respiration_node.tscn")
var pode_criar_nota := true
var esperando_nova_nota := false
var acertos_consecutivos := 0
const HIT_WINDOW := 40.0
var passou := false

func trocar_cena():
	get_tree().change_scene_to_file("res://scenes/maps/caverna_bifurcacao.tscn")
	
func iniciar_dialogos():
	var conversa = [
		{
			"sujeito": "???",
			"texto": "Não vi você aí. Está tudo bem?"
		},
		{
			"sujeito": "Lucy",
			"texto": "Acho que sim... Isso tudo parece tão real, mas ao mesmo tempo..."
		},
		{
			"sujeito": "???",
			"texto": "Vamos começar aos poucos, como você se chama?"
		},
		{
			"sujeito": "Lucy",
			"texto": "Eu me chamo Lucy..."
		},
		{
			"sujeito": "Lucy",
			"texto": "Qual é o seu nome?... e por que carrega tanta coisa nas costas?"
		},
		{
			"sujeito": "Luthier",
			"texto": "Eu sou Luthier, cuido dos instrumentos so subsolo."
		},
		{
			"sujeito": "Luthier",
			"texto": "Consegue se levantar, Lucy?"
		},
		{
			"sujeito": "Lucy",
			"texto": "Sim, parece que a queda que eu tive não me machucou.",
			"animacao": "lucy_levanta"
		},
		{
			"sujeito": "Luthier",
			"texto": "Ótimo! E o que você está fazendo sozinha por aqui?.",
		},
		{
			"sujeito": "Lucy",
			"texto": "É... Eu ouvi um barulho enquanto eu dormia...",
		},
		{
			"sujeito": "Lucy",
			"texto": "Eu sai de casa para ver o que era e então caí nesse buraco.",
		},
		{
			"sujeito": "Lucy",
			"texto": "Por que quer saber?",
		},
		{
			"sujeito": "Luthier",
			"texto": "Você não é daqui mesmo não é?",
		},
		{
			"sujeito": "Luthier",
			"texto": "O subsolo foi interditado pelas criaturas que existem aqui...",
		},
		{
			"sujeito": "Luthier",
			"texto": "Por isso serve bem como esconderijo.",
		},
		{
			"sujeito": "Luthier",
			"texto": "Mas para andar por aqui você vai precisar de uma arma.",
		},
		{
			"sujeito": "Lucy",
			"texto": "Tipo aquelas espadas gigantes ou pistolas?",
		},
		{
			"sujeito": "Luthier",
			"texto": "Não, nada disso tem efeito nas criaturas que ficam aqui.",
		},
		{
			"sujeito": "Luthier",
			"texto": "Para lutar você vai precisar de um instrumento. Elas são bem sensíveis a certas frequências.",
		},
		{
			"sujeito": "Luthier",
			"texto": "O que você toca? Temos teclados, guitarras, violinos, gaitas...",
		},
		{
			"sujeito": "Lucy",
			"texto": "Eu tenho um baixo em casa.",
		},
		{
			"sujeito": "Luthier",
			"texto": "Baixo? Ótimo! Me lembro de ter um aqui comigo.",
		},
		{
			"sujeito": "Luthier",
			"texto": "Você é a segunda baixista que eu vejo por aqui.",
		},
		{
			"sujeito": "Lucy",
			"texto": "E quem foi a primeira...?",
		},
		{
			"sujeito": "Luthier",
			"texto": "Aqui, achei!",
		},
		{
			"sujeito": "Luthier",
			"texto": "Não sei muito bem o que aconteceu com a primeira, mas a moça no caminho atrás de você sabe mais do que eu.",
		},
		{
			"sujeito": "Lucy",
			"texto": "Tudo bem, e obrigado pelo baixo.",
		},
		{
			"sujeito": "Lucy",
			"texto": "Se eu não conseguir tocar talvez consiga improvisar algo com ele.",
		},
		{
			"sujeito": "...",
			"texto": "",
			"animacao": "fade_out"			
		}
	]

	DialogueBox.show_conversation(conversa)

func _ready():
	DialogueBox.line_started.connect(_on_line_started)
	MusicManager.tocar_musica(load("res://assets/msc/queda.mp3"), -10)

func _on_line_started(fala: Dictionary):
	if fala.has("animacao"):
		animation_player.play(fala["animacao"])

func musica_luthier():
	MusicManager.tocar_musica(load("res://assets/msc/luthier.mp3"),-10)

func play_levantando():
	monstro_1.play("surgindo")
	monstro_2.play("surgindo")
	
func play_transformando():
	monstro_1.play("transformando")
	monstro_2.play("transformando")
	
func play_andando():
	monstro_1.play("andando")
	monstro_2.play("andando")
	
func play_luthier_idle_sax():
	luthier.play("idle_sax")
	
func play_luthier_idle():
	luthier.play("idle")
	
func play_destruindo():
	monstro_1.play("destruindo")
	monstro_2.play("destruindo")
	
func play_luthier_guardando_sax():
	luthier.play("guardando")
	
func play_cabeça_levantando():
	anim_lucy.play("cabeça_levantando")

func play_cabeça_abaixando():
	anim_lucy.play("cabeça abaixando")
	
func play_levantando_chao():
	anim_lucy.play("levantando_do_chao")

func play_cabeça_baixa():
	anim_lucy.play("parado_cabeça_baixo")

func play_cabeça_alta():
	anim_lucy.play("parado_cabeça_cima")

func play_lucy_idle():
	anim_lucy.play("idle")

func _input(event):
	if event.is_action_pressed("respirar"):
		anim.play("apertado")
		tentar_acertar()
		await get_tree().create_timer(0.25).timeout
		anim.play("idle")


func _process(_delta):
	if acertos_consecutivos == 15 :
		passou = !passou;
		animation_player.play("luthier")
	if bolinhas.get_child_count() == 0:
		return

	for note in bolinhas.get_children():
		if note.global_position.x < hit_position.global_position.x - 30:

			acertos_consecutivos = max(acertos_consecutivos - 2, 0)

			atualizar_foco()
			note.queue_free()
	

func tentar_acertar():
	if esperando_nova_nota:
		return

	if bolinhas.get_child_count() == 0:
		return

	var note = bolinhas.get_child(0)
	var menor_distancia = INF

	for n in bolinhas.get_children():
		var distancia = abs(
			n.global_position.x - hit_position.global_position.x
		)

		if distancia < menor_distancia:
			menor_distancia = distancia
			note = n

	var distancia = menor_distancia


	if distancia <= HIT_WINDOW:
		anim_lucy.play("respirando")
		acertos_consecutivos += 1
		atualizar_foco()

		note.queue_free()
	else:
		acertos_consecutivos = max(acertos_consecutivos - 2, 0)
		atualizar_foco()


func atualizar_foco():
	foco_atual = FOCO_MINIMO + (acertos_consecutivos * FOCO_POR_ACERTO)
	foco_atual = min(foco_atual, FOCO_MAXIMO)

	var material = focus_overlay.material as ShaderMaterial
	material.set_shader_parameter("focus_radius", foco_atual)




func spawn_note():
	var note = respiration_note.instantiate()
	bolinhas.add_child(note)

	note.position = Vector2(
		hit_position.position.x + 900,
		hit_position.position.y
	)
	
func iniciar_spawn():
	while !passou:
		spawn_note()
		await get_tree().create_timer(intervalo_spawn+(acertos_consecutivos/6)).timeout


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_lucy.animation == "respirando":
		anim_lucy.play("chorando")


func _on_dialogue_box_finished() -> void:
	pass # Replace with function body.
