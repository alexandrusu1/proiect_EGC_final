

extends Control

# Daca nodurile sunt direct sub ExamUI (fara Panel parinte)
@onready var text_lbl = $Panel/TextIntrebare
@onready var btn_a = $Panel/TextIntrebare/Button
@onready var btn_b = $Panel/TextIntrebare/Button2
@onready var btn_c =$Panel/TextIntrebare/Button3
@onready var btn_d = $Panel/TextIntrebare/Button4

var id_curent = 0
var foaie_referinta = null

func _ready():
	visible = false # Ascuns la start

func deschide(id, foaie):
	id_curent = id
	foaie_referinta = foaie
	
	var data = GameManager.intrebari[id]
	text_lbl.text = data["q"]
	btn_a.text = data["a"][0]
	btn_b.text = data["a"][1]
	btn_c.text = data["a"][2]
	btn_d.text = data["a"][3]
	
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func apasa_buton(index):
	var e_bun = GameManager.verifica_raspuns(id_curent, index)
	
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if e_bun:
		if foaie_referinta:
			foaie_referinta.queue_free() # Sterge foaia daca ai raspuns bine

# Legaturile butoanelor
func _on_ButonA_pressed(): apasa_buton(0)
func _on_ButonB_pressed(): apasa_buton(1)
func _on_ButonC_pressed(): apasa_buton(2)
func _on_ButonD_pressed(): apasa_buton(3)
