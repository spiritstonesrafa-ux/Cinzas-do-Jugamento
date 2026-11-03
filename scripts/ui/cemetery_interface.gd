extends PixelCanvas
## Compact presentation adapter. Original stage labels/text and camera logic stay intact.
var _sector: Label
var _hint: Label
var _font: Font
var _last_sector: String = ""
var _last_hint: String = ""

func _ready() -> void:
	_sector = get_parent().get_node("Sector") as Label
	_hint = get_parent().get_node("Hint") as Label
	_font = _sector.get_theme_font("font")
	_sector.visible = false
	_hint.visible = false

func _process(_delta: float) -> void:
	if _sector.text != _last_sector or _hint.text != _last_hint:
		_last_sector = _sector.text
		_last_hint = _hint.text
		queue_redraw()

func _draw() -> void:
	if _font == null: return
	# Sector name occupies the free top-right, never a second stack above gameplay.
	var title: String = _sector.text
	var width: int = ceili(_font.get_string_size(title,HORIZONTAL_ALIGNMENT_LEFT,-1,8).x)
	r(312-width-5,2,width+9,12,Color("10111f",0.63))
	l(Vector2(312-width,14),Vector2(312,14),Color("88755e",0.55))
	draw_string(_font,Vector2(312-width,11),title,HORIZONTAL_ALIGNMENT_LEFT,-1,8,Color("c1c4b5"))
	var notice: String = display_notice()
	if notice.is_empty(): return
	var text_width: int = ceili(_font.get_string_size(notice,HORIZONTAL_ALIGNMENT_LEFT,-1,8).x)
	var left: int = 160-text_width/2
	r(left-7,165,text_width+14,12,Color("10111f",0.80))
	l(Vector2(left-3,165),Vector2(left+text_width+3,165),Color("827257",0.65))
	draw_string(_font,Vector2(left,174),notice,HORIZONTAL_ALIGNMENT_LEFT,-1,8,Color("c5bd9e"))

func display_notice() -> String:
	var notice: String = _hint.text
	if notice.begins_with("INÍCIO"):
		return "A/D mover   Espaço saltar   J espada"
	if notice.begins_with("FIM PROVISÓRIO"):
		return "Fim provisório da fase · aguarda playtest"
	return notice
