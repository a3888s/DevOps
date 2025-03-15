from http.server import HTTPServer, BaseHTTPRequestHandler

# Клас для обробки HTTP-запитів
class SimpleHandler(BaseHTTPRequestHandler):
    # Обробка GET-запитів
    def do_GET(self):
        if self.path == "/":  # Якщо запитаний кореневий маршрут
            self.send_response(200)  # Відправка відповіді зі статусом 200 (OK)
            self.end_headers()  # Завершення заголовків відповіді
            html_content = """
                <!DOCTYPE html>
                <html>
                <head>
                    <title>StepFinalProject</title>
                    <style>
                        body {
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            margin: 0;
                            font-family: Arial, sans-serif;
                            background-color: #f4f4f9;
                        }
                        h1 {
                            color: #333;
                        }
                    </style>
                </head>
                <body>
                    <h1>StepFinalProject v1.0.2</h1>
                </body>
                </html>
            """
            self.wfile.write(html_content.encode("utf-8"))  # Відправка HTML-контенту
        else:
            self.send_response(404)  # Відправка відповіді зі статусом 404 (Not Found)
            self.end_headers()
            self.wfile.write(b"404 Not Found")  # Відправка тексту 404

# Основна частина програми
if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), SimpleHandler)  # Ініціалізація сервера на порту 8080
    version = "v1.0.2"
    print(f"StepFinalProject {version}")  # Виведення інформації про запуск у консоль
    server.serve_forever()  # Запуск сервера для обробки запитів
