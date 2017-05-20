extends ItemList

export (Texture) var item1
func _ready():
	add_item("TEST")
	add_icon_item(item1)
	set_item_tooltip(0, "is this working?")
	set_process(true)

func _process(delta):
	if is_selected(0):
		print("hello")

