class University:
    def __init__(self, name: str, address: str, budget: int):
        self.name = name
        self.address = address
        self.budget = budget
        self.faculties = []

    def add_faculty(self, faculty: str):
        self.faculties.append(faculty)
    
    def add_budget(self, money: int):
        self.budget += money
        
    def remove_budget(self, money: int):
        if money > self.budget:
            print('Недостаточно средств')
        else:
            self.budget = self.budget - money
    
    def change_adress(self, new_address: str):
        self.address = new_address

class Faculty:
    def __init__(self, name: str, specialization: str, num_teachers: int):
        self.name = name
        self.specialization = specialization
        self.num_teachers = num_teachers
        self.students = []

    def add_student(self, student: str):
        self.students.append(student)
        
    def add_teacher(self):
        self.num_teachers += 1
    
    def remove_student(self, student: str):
        self.students.remove(student)
        
    def remove_teacher(self):
        self.num_teachers -= 1
    
    def change_spec(self, new_spec: str):
        self.specialization = new_spec

class Student:
    def __init__(self, name: str, group: int, performance: str):
        self.name = name
        self.group = group
        self.performance = performance

    def change_group(self, new_group: int):
        self.group = new_group
        
    def change_perfomance(self, new_perf: str):
        self.performance = new_perf
        
    def next_course(self):
        if self.group > 399:
            print("Студент выпустился!")
            self.group = None
        else:
            self.group += 100
        
def main():
    unik1 = University('MSPU', 'Vernadka, 88', 100000)
    fac1 = Faculty('IIE', 'languages', 30)
    unik1.add_faculty(fac1.name)
    print(unik1.faculties)
    stud1 = Student('Alexandr', 333, 'НЕРЕАЛЬНО ИДЕАЛЬНАЯ')
    fac1.add_student(stud1.name)
    print(fac1.students)
    
    print(stud1.performance)
    stud1.change_perfomance("Очень плохо")
    print(stud1.performance)
    
    print(stud1.group)
    stud1.next_course()
    print(stud1.group)
    stud1.next_course()
    print(stud1.group)
    
if __name__ == "__main__":
    main()