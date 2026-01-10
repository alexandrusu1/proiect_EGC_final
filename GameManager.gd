extends Node

var greseli = 0


var intrebari = [
	{
		"q": "Cat face 2 + 2?",
		"a": ["3", "4", "5", "10"],
		"corect": 1 
	},
	{
		"q": "Care este capitala Frantei?",
		"a": ["Paris", "Londra", "Roma", "Berlin"],
		"corect": 0
	},
	{
		"q": "Ce culoare are cerul senin?",
		"a": ["Verde", "Rosu", "Albastru", "Galben"],
		"corect": 2
	}
	
]


func verifica_raspuns(index_intrebare, index_raspuns_ales):
	var raspuns_corect = intrebari[index_intrebare]["corect"]
	
	if index_raspuns_ales == raspuns_corect:
		print("Corect!")
		return true
	else:
		greseli += 1
		print("Gresit! Total greseli: ", greseli)
		verificare_game_over()
		return false


func verificare_game_over():
	if greseli >= 3:
		print("Ai pierdut! Se reincepe jocul.")
		greseli = 0 
		get_tree().reload_current_scene()
