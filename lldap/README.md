---
Щоб успішно імпортувати 5000 користувачів у LLDAP із користувацькими полями (`ats-2`, `mats`, `any_number`), потрібно дотриматись **точного GraphQL формату**, в якому атрибути передаються окремим масивом об’єктів виду:

```json
"attributes": [
  { "name": "ats-2", "value": ["37898"] },
  { "name": "mats", "value": ["0442307654"] },
  { "name": "any_number", "value": ["1"] }
]
```

Також у схемі GraphQL не існує поля `password` — пароль встановлюється окремим запитом або інструментом, як `lldap_set_password`.

---

### ✅ Приклад правильного GraphQL запиту на створення користувача:

```graphql
mutation CreateUser($user: CreateUserInput!) {
  createUser(user: $user) {
    id
  }
}
```

### 📦 JSON змінні (`variables`):

```json
{
  "user": {
    "id": "37898",
    "email": "37898@example.com",
    "displayName": "User 37898",
    "firstName": "User",
    "lastName": "37898",
    "attributes": [
      { "name": "ats-2", "value": ["37898"] },
      { "name": "mats", "value": ["0442307654"] },
      { "name": "any_number", "value": ["1"] }
    ]
  }
}
```

---

### 🔁 Автоматизація для 5000 користувачів

1. **Згенеруй JSON масив у Bash через `jq` (встанови jq):**

```bash
jq -n '[range(37898; 42898) | {
  id: tostring,
  email: (tostring + "@example.com"),
  displayName: ("User " + tostring),
  firstName: "User",
  lastName: tostring,
  attributes: [
    {name: "ats-2", value: [tostring]},
    {name: "mats", value: ["0442307654"]},
    {name: "any_number", value: ["1"]}
  ]
}]' > users.json
```

2. **Запусти Python-скрипт, який по черзі надсилає GraphQL-запити:**

```python
import json
import requests

URL = "http://localhost:17170/api/graphql"
TOKEN = "<твій_JWT_токен_тут>"

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
```

---

### 🔑 Як встановити пароль?

Після створення користувача, пароль задається через утиліту `lldap_set_password`:

```bash
/app/lldap_set_password --base-url http://localhost:17170 --token <JWT> --username 37898 --password StrongPass123!
```
---
