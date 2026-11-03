extends Node2D
var boss: OathGuardian
var font: Font=ThemeDB.fallback_font
func _process(_delta: float) -> void:queue_redraw()
func _draw() -> void:
 if not is_instance_valid(boss):return
 var name_text: String="GUARDIÃO DO JURAMENTO"
 var width: float=font.get_string_size(name_text,HORIZONTAL_ALIGNMENT_LEFT,-1,8).x
 draw_rect(Rect2(62,19,196,24),Color("10111f",0.88))
 draw_string(font,Vector2((320-width)/2,28),name_text,HORIZONTAL_ALIGNMENT_LEFT,-1,8,Color("dbc7a0"))
 draw_rect(Rect2(76,32,168,6),Color("89765e"))
 draw_rect(Rect2(77,33,166,4),Color("272337"))
 draw_rect(Rect2(77,33,166*float(boss.current_health)/boss.max_health,4),Color("8c3d55"))
 var notice: String=""
 if boss.state==OathGuardian.State.INTRO:notice="O antigo protetor desperta."
 elif boss.state==OathGuardian.State.DEFEATED:notice="Guardião vencido · retorne pelo selo à esquerda"
 if not notice.is_empty():
  var text_width: float=font.get_string_size(notice,HORIZONTAL_ALIGNMENT_LEFT,-1,7).x
  draw_rect(Rect2(14,164,292,14),Color("10111f",0.9))
  draw_string(font,Vector2((320-text_width)/2,174),notice,HORIZONTAL_ALIGNMENT_LEFT,-1,7,Color("e3d2ac"))
