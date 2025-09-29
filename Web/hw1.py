class Phone:
    def __init__(self, brand, serial_number, battery):
        self.brand: str = brand
        self.serial_number: str = serial_number
        self.battery: int = battery
     
    def charge(self, step):
        charging = self.battery
        while charging < 100:
            charging = charging + step
            if charging >= 100:
                print(f'Телефон "{self.brand}" полностью заряжен!')
                charging = 100
            else:
                print(f'Телефон "{self.brand}" зарядился до {charging}%')
        self.battery = charging

    def __str__(self) -> str:
        return f'{self.brand}: {self.serial_number}, {self.battery}%'


def main():
    p1 = Phone('Samsung', '43432', 67)
    p1.charge(2)
    print(p1)
    
if __name__ == '__main__':
    main()