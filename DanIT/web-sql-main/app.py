from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)

db_user = os.getenv('DB_USER', 'flaskuser')
db_password = os.getenv('DB_PASSWORD', 'flaskpassword')
db_host = os.getenv('DB_HOST', 'db')
db_name = os.getenv('DB_NAME', 'mydatabase')

app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Data(db.Model):
  id = db.Column(db.Integer, primary_key=True)
  value = db.Column(db.String(255), nullable=False)

  def __repr__(self):
    return '<Data %r>' % self.value

@app.route('/add', methods=['POST'])
def add_data():
  value = request.json['value']
  data = Data(value=value)
  db.session.add(data)
  db.session.commit()

  return jsonify({"message": "Data added successfully"}), 201

@app.route('/fetch', methods=['GET'])
def fetch_data():
  data = Data.query.all()
  return jsonify([{'id': item.id, 'value': item.value} for item in data]), 200

@app.route('/health', methods=['GET'])
def health():
  return jsonify({'status': 'health'}), 200

if __name__ == '__main__':
  app.run(host="0.0.0.0", port=5000)