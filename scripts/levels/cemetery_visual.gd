@tool
extends Node2D
## Original greybox notation only. White rims belong to solid scene geometry.

func _draw() -> void:
	draw_rect(Rect2(0, 0, 2368, 320), Color("15191f"))
	var starts: Array[int] = [0, 384, 768, 1152, 1536, 1984]
	for index: int in range(starts.size()):
		var x: int = starts[index]
		draw_rect(Rect2(x, 48, 2, 240), Color("343b43"))
		# Direction arrows are background marks, never collision surfaces.
		draw_line(Vector2(x + 40, 88), Vector2(x + 64, 88), Color("9a936e"), 2)
		draw_line(Vector2(x + 64, 88), Vector2(x + 58, 82), Color("9a936e"), 2)
		draw_line(Vector2(x + 64, 88), Vector2(x + 58, 94), Color("9a936e"), 2)
	# Gate outlines, grave silhouettes and crypt backing use low contrast.
	for x: int in [16, 112, 2224, 2336]:
		draw_rect(Rect2(x, 64, 8, 92), Color("42464b"))
	draw_rect(Rect2(16, 64, 104, 8), Color("42464b"))
	draw_rect(Rect2(2224, 64, 120, 8), Color("42464b"))
	for x: int in [400, 504, 600, 704, 800, 944]:
		draw_rect(Rect2(x, 106, 14, 32), Color("363d44"))
		draw_rect(Rect2(x - 3, 106, 20, 4), Color("363d44"))
	draw_rect(Rect2(1152, 64, 352, 224), Color("1d242c"))
	# Dashed outlines identify future checkpoint space without an active flag.
	for x: int in [1040, 1936]:
		for y: int in range(122, 154, 8):
			draw_rect(Rect2(x - 10, y, 2, 4), Color("c1a66d"))
			draw_rect(Rect2(x + 10, y, 2, 4), Color("c1a66d"))
		draw_line(Vector2(x - 10, 154), Vector2(x + 12, 154), Color("c1a66d"), 2)
	draw_rect(Rect2(34, 151, 28, 4), Color("9eaf93"))
	draw_rect(Rect2(2256, 151, 64, 4), Color("c1a66d"))
	# Readable pit lips. These marks have no independent gameplay behavior.
	for p: Vector2 in [Vector2(440,156), Vector2(480,144), Vector2(536,144),
		Vector2(576,156), Vector2(632,156), Vector2(672,140),
		Vector2(1592,156), Vector2(1632,148), Vector2(1704,148),
		Vector2(1752,144), Vector2(1840,144), Vector2(1888,156)]:
		draw_rect(Rect2(p - Vector2(0,4), Vector2(8,4)), Color("c1a66d"))
