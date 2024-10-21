extends Object
class_name CircleLayoutLogic

var circle_radius: float

func _init(cirlce_radius: float) -> void:
	circle_radius = cirlce_radius


"""
Функция нахождения позиции на сфере (оси X и Y - круг).
Вход: Угол как для обычного координатного круга
Выход: координаты точки, угол (в градусах) между 0углом и точкой.
"""
func get_card_position(angle_xy: float):
	# 90 т.к. для "руки" 0угол это верх круга.
	angle_xy = abs(angle_xy - 90)
	var radius: float = self.circle_radius
	var x: float = radius * cos(deg_to_rad(angle_xy))
	var y: float = radius * sin(deg_to_rad(angle_xy))
	var k: float = get_vector_angle(x, y, 0, 1)
	return [x, y, k]

"""
Функция нахождения угла между векторами (оси X и Y - круг)
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
	var start = (left + right) / 2
	
	if n > max_n:
		step = (right - left ) / n
	
	if n % 2 == 0:
		for i in range(n / 2):
			points.append(start + step * i + step / 2)
			points.append(start - step * i - step / 2)
	else:
		points.append(start)
		for i in range((n - 1) / 2):
			points.append(start + step * i + step)
			points.append(start - step * i - step)
	
	points.sort()
	return points


func move_apart(n: int, selected_card_index: int, left: float = -15.0, right: float = 15.0, step: float = 6.0):
	var coords = distribute_points_with_max_distance(n)
	
	if n < 3:
		return coords
		
	var select = []
	var before = selected_card_index - 1
	if before < 0:
		before = 0
	var after = n - selected_card_index - 2
	
	if selected_card_index > 0:
		select.append(coords[selected_card_index - 1] - step * 2)
	select.append(coords[selected_card_index])
	if selected_card_index < n - 1:
		select.append(coords[selected_card_index + 1] + step * 2)
	
	var coords_before = []
	var coords_after = []
	if before > 0:
		coords_before = distribute_points_with_max_distance(before, -30, coords[selected_card_index] - step * 2.5)
	if after > 0:
		coords_after = distribute_points_with_max_distance(after, coords[selected_card_index] + step * 2.5, 30)

	return coords_before + select + coords_after
	


	
	
