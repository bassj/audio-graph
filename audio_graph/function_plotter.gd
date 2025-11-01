extends Control
class_name FunctionPlotter

var function: Callable
var steps: int = 100

func _draw():
    if not function:
        return

    for i in range(steps):
        var phase = float(i) / float(steps)
        var next_phase = float(i + 1) / float(steps)

        var y1 = function.call(phase)
        var y2 = function.call(next_phase)

        var p1 = Vector2(phase * size.x, (1.0 - y1) * size.y * 0.5)
        var p2 = Vector2(next_phase * size.x, (1.0 - y2) * size.y * 0.5)

        draw_line(p1, p2, Color.RED, 1.0)
