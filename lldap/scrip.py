import requests
import json

URL = "http://10.0.0.77:17170/api/graphql"
TOKEN = "eyJhbGciOiJIUzUxMiJ9.eyJleHAiOiIyMDI1LTA0LTEwVDE0OjU2OjQ1LjM4MDk5MzA4NFoiLCJpYXQiOiIyMDI1LTA0LTA5VDE0OjU2OjQ1LjM4MDk5MzQzMloiLCJ1c2VyIjoiYWRtaW4iLCJncm91cHMiOlsibGxkYXBfYWRtaW4iXX0.XG7UFj4891rI1sD0SeyW-svCHslnJcrAFjHSA2AfJMTQ4PrICmDOEk3mT9RwskOiFg_XKO-XO_uIBdjIPSnc6w"  # Встав свій токен
HEADERS = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {TOKEN}"
}

QUERY = """
mutation CreateUser($user: CreateUserInput!) {
  createUser(user: $user) {
    id
  }
}
"""

with open("users.json") as f:
    users = json.load(f)

for user in users:
    payload = {
        "query": QUERY,
        "variables": {"user": user}
    }
    response = requests.post(URL, headers=HEADERS, json=payload)
    print(response.json())