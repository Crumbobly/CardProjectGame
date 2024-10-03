extends StaticBody2D

@onready var circle = $CollisionCircle

"""
Функция нахождения позиции на круге.
Вход: Угол как для обычного координатного круга
Выход: координаты точки, угол (в градусах) между 0углом и точкой.
"""
func get_card_position(angle: float):
	# -90 т.к. для "руки" 0угол это верх круга.
	angle -= 90
	var radius: float = circle.shape.radius
	var x: float = radius * cos(deg_to_rad(angle))
	var y: float = radius * sin(deg_to_rad(angle))
	var k: float = get_vector_angle(x, y, 0, -1)
	return [x, y, k]

"""
Функция нахождения угла между векторами
Вход: Две точки
Выход: Угол в градусах
"""
func get_vector_angle(x1: float, y1: float, x2: float, y2: float):
	var angle = acos(
		(abs(x1*x2) + abs(y1*y2))
		/
		(sqrt(pow(x1, 2) + pow(y1, 2)) * sqrt(pow(x2, 2) + pow(y2, 2)))
	)
	if (x1 < 0):
		return rad_to_deg(-angle)
	return rad_to_deg(angle)
	

"""
Фунция распределения точек на отезке.
Находит расположение точек на отрезке по следующим правилам:
	1. Расстояние между всеми (n) точками равно
	2. Расстояние между всеми (n) точками равно step если это возможно
	3. Если число точек четноё, то слева с справа от середины отрезка их число одинаково
	4. Если число точек нечетно, то середина отрезка - точка, и (3.)

In: n=4
Output: [-9, -3, 3, 9]

In: n=5
Output: [-12, -6, 0, 6, 12]

Вход: Кол-во точек, левая граница отрезка, правая граница отрезка, максимальное расстояние между точками
Выход: Список координат точек.
"""
func distribute_points_with_max_distance(n: int, left: float = -15.0, right: float = 15.0, step: float = 6.0):
	var max_n: int = (right - left ) / step
	var points = []
	
	if n > max_n:
		step = (right - left ) / n
	
	if n % 2 == 0:
		for i in range(n / 2):
			points.append(step * i + step / 2)
			points.append(- step * i - step / 2)
	else:
		points.append(0)
		for i in range((n - 1) / 2):
			points.append(step * i + step)
			points.append(- step * i - step)
	
	points.sort()
	return points
