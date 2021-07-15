extends VBoxContainer

func hide_children():
	$TopLevel.hide()
	$BottomLevel.hide()
	
func show_children():
	$TopLevel.show()
	$BottomLevel.show()
