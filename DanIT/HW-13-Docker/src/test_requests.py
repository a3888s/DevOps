import requests
import json

BASE_URL = 'http://localhost:8000'

def print_response(response):
    try:
        response_json = response.json()
        formatted_response = json.dumps(response_json, indent=4)
    except json.JSONDecodeError:
        formatted_response = response.text  # Повертаємо текст відповіді, якщо він не є дійсним JSON

    print(formatted_response)
    with open('results.txt', 'a') as file:
        file.write(formatted_response + '\n')

# Отримати всіх існуючих студентів
response = requests.get(f'{BASE_URL}/students')
print_response(response)

# Створити трьох студентів
students_data = [
    {'first_name': 'Olexndr', 'last_name': 'Skibchyk', 'age': 32},
    {'first_name': 'Oleksii', 'last_name': 'Pupkin', 'age': 22},
    {'first_name': 'Andrii', 'last_name': 'Bandera', 'age': 23},
]

for student in students_data:
    response = requests.post(f'{BASE_URL}/students', json=student)
    print_response(response)

# Отримати інформацію про всіх існуючих студентів
response = requests.get(f'{BASE_URL}/students')
print_response(response)

# Оновити вік другого студента
response = requests.patch(f'{BASE_URL}/students/2/age', json={'age': 24})
print_response(response)

# Отримати інформацію про другого студента
response = requests.get(f'{BASE_URL}/students/2')
print_response(response)

# Оновити ім'я, прізвище та вік третього студента
response = requests.put(f'{BASE_URL}/students/3', json={'first_name': 'Taras', 'last_name': 'Prepod', 'age': 25})
print_response(response)

# Отримати інформацію про третього студента
response = requests.get(f'{BASE_URL}/students/3')
print_response(response)

# Отримати всіх існуючих студентів
response = requests.get(f'{BASE_URL}/students')
print_response(response)

# Видалити першого студента
response = requests.delete(f'{BASE_URL}/students/1')
print_response(response)

# Отримати всіх існуючих студентів
response = requests.get(f'{BASE_URL}/students')
