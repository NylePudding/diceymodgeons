extends PanelContainer

onready var TabContainer = find_node("TabContainer")
onready var CharacterList = find_node("CharacterList")

onready var Data = find_node("Data")
onready var Graphics = find_node("Graphics")
onready var Descriptions = find_node("Descriptions")

func _ready():
	TabContainer.visible = false

func _on_CharacterList_item_selected(key):
	if not TabContainer: return
	if key == null or key.empty(): 
		TabContainer.visible = false
		return
		
	var data = Database.commit(Database.Table.CHARACTERS, Database.READ, key)
	TabContainer.visible = true
	Data.set_data(data)
	Descriptions.set_data(data)

func _on_CharacterList_add_button_pressed():
	pass # Replace with function body.