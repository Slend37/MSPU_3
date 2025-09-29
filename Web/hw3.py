class Vehicle:
    def __init__(self, make, max_speed):
        self.make = make
        self.max_speed = max_speed

    def info(self):
        return f"Марка: {self.make}, Максимальная скорость: {self.max_speed}"

class Car(Vehicle):
    def __init__(self, make, max_speed, passenger_seats):
        super().__init__(make, max_speed)
        self.passenger_seats = passenger_seats

    def info(self):
        return f"Марка: {self.make}, Максимальная скорость: {self.max_speed}, Количество пассажирских мест: {self.passenger_seats}"

class Train(Vehicle):
    def __init__(self, make, max_speed, carriages_count):
        super().__init__(make, max_speed)
        self.carriages_count = carriages_count

    def info(self):
        return f"Марка: {self.make}, Максимальная скорость: {self.max_speed}, Количество вагонов: {self.carriages_count}"

car1 = Car("Moskvich", 400, 4)
train1 = Train("RJD", 150, 12)

print(car1.info())
print(train1.info())