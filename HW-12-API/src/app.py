from flask import Flask, request, jsonify
import csv
import os

app = Flask(__name__)
CSV_FILE = 'students.csv'

# Перевіряємо, чи існує файл, якщо ні - створюємо
if not os.path.exists(CSV_FILE):
    with open(CSV_FILE, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['id', 'first_name', 'last_name', 'age'])

def read_students():
    students = []
    with open(CSV_FILE, mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            students.append(row)
    return students

def write_students(students):
    with open(CSV_FILE, mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'first_name', 'last_name', 'age'])
        writer.writeheader()
        writer.writerows(students)  # Використовуємо writerows для запису списку студентів

# GET: Отримати всіх студентів
@app.route('/students', methods=['GET'])
def get_students():
    students = read_students()
    return jsonify(students), 200

# GET: Отримати студента за ID
@app.route('/students/<int:student_id>', methods=['GET'])
def get_student_by_id(student_id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        return jsonify(student), 200
    return jsonify({'error': 'Student not found'}), 404

# GET: Отримати студентів за прізвищем
@app.route('/students/lastname/<string:last_name>', methods=['GET'])
def get_students_by_last_name(last_name):
    students = read_students()
    matched_students = [s for s in students if s['last_name'].lower() == last_name.lower()]
    if matched_students:
        return jsonify(matched_students), 200
    return jsonify({'error': 'No students found with that last name'}), 404

# POST: Створити нового студента
@app.route('/students', methods=['POST'])
def create_student():
    new_student = request.get_json()
    if 'first_name' not in new_student or 'last_name' not in new_student or 'age' not in new_student:
        return jsonify({'error': 'Missing fields in request'}), 400
    
    students = read_students()
    new_id = max([int(s['id']) for s in students], default=0) + 1
    new_student['id'] = new_id
    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

# PUT: Оновити інформацію про студента за ID
@app.route('/students/<int:student_id>', methods=['PUT'])
def update_student(student_id):
    update_data = request.get_json()
    if 'first_name' not in update_data or 'last_name' not in update_data or 'age' not in update_data:
        return jsonify({'error': 'Missing fields in request'}), 400
    
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        student['first_name'] = update_data['first_name']
        student['last_name'] = update_data['last_name']
        student['age'] = update_data['age']
        write_students(students)
        return jsonify(student), 200
    return jsonify({'error': 'Student not found'}), 404

# PATCH: Оновити вік студента за ID
@app.route('/students/<int:student_id>/age', methods=['PATCH'])
def update_student_age(student_id):
    update_data = request.get_json()
    if 'age' not in update_data:
        return jsonify({'error': 'Missing age field in request'}), 400
    
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        student['age'] = update_data['age']
        write_students(students)
        return jsonify(student), 200
    return jsonify({'error': 'Student not found'}), 404

# DELETE: Видалити студента за ID
@app.route('/students/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        students = [s for s in students if int(s['id']) != student_id]
        write_students(students)
        return jsonify({'message': 'Student deleted successfully'}), 200
    return jsonify({'error': 'Student not found'}), 404

if __name__ == '__main__':
    app.run(debug=True)
