extends Control


@onready var text_intrebare = $Panel/TextIntrebare
@onready var btn_a = $Panel/Button   # Primul buton
@onready var btn_b = $Panel/Button2  # Al doilea
@onready var btn_c = $Panel/Button3  # Al treilea
@onready var btn_d = $Panel/Button4  # Al patrulea

var id_intrebare_curenta = 0
var foaie_referinta = null

func _ready():
	visible = false 


func arata_intrebare(id, obiect_foaie):
	id_intrebare_curenta = id
	foaie_referinta = obiect_foaie
	

	var data = GameManager.intrebari[id]
	
	text_intrebare.text = data["q"]
	btn_a.text = data["a"][0]
	btn_b.text = data["a"][1]
	btn_c.text = data["a"][2]
	btn_d.text = data["a"][3]

	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func verifica(index):
	var corect = GameManager.verifica_raspuns(id_intrebare_curenta, index)
	
	if corect:
	
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if foaie_referinta:
			foaie_referinta.queue_free()
	else:
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_ButonA_pressed(): verifica(0)
func _on_ButonB_pressed(): verifica(1)
func _on_ButonC_pressed(): verifica(2)
func _on_ButonD_pressed(): verifica(3)
