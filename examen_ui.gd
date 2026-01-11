extends Control

@onready var text_lbl = $Panel/TextIntrebare
@onready var btn_a = $Panel/TextIntrebare/Button
@onready var btn_b = $Panel/TextIntrebare/Button2
@onready var btn_c = $Panel/TextIntrebare/Button3
@onready var btn_d = $Panel/TextIntrebare/Button4

# Această listă este obligatorie pentru a găsi butoanele!
@onready var lista_butoane = [btn_a, btn_b, btn_c, btn_d]

var id_curent = 0
var foaie_referinta = null

func _ready():
	visible = false

func deschide(id, foaie):
	id_curent = id
	foaie_referinta = foaie
	var data = GameManager.intrebari[id]
	text_lbl.text = data["q"]
	btn_a.text = data["a"][0]
	btn_b.text = data["a"][1]
	btn_c.text = data["a"][2]
	btn_d.text = data["a"][3]
	
	for btn in lista_butoane:
		btn.remove_theme_color_override("font_color")
		
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func apasa_buton(index):
	var e_bun = GameManager.verifica_raspuns(id_curent, index)
	var tree = get_tree()
	
	if e_bun:
		visible = false
		if not GameManager.joc_finalizat:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if foaie_referinta: foaie_referinta.queue_free()
	else:
		if index < lista_butoane.size():
			lista_butoane[index].add_theme_color_override("font_color", Color.RED)
		
		if not GameManager.este_game_over():
			var inamic = tree.get_first_node_in_group("Inamic")
			if inamic:
				inamic.creste_dificultatea()
				if inamic.has_method("vine_la_jucator"):
					inamic.vine_la_jucator()
			
			await tree.create_timer(0.3).timeout 
			visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			await tree.create_timer(0.5).timeout
			visible = false

func _on_ButonA_pressed(): apasa_buton(0)
func _on_ButonB_pressed(): apasa_buton(1)
func _on_ButonC_pressed(): apasa_buton(2)
func _on_ButonD_pressed(): apasa_buton(3)
