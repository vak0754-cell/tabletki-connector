# Tabletki.ua Connector — Повний проєкт

Готовий клієнтський конектор для пошуку ліків, цін, наявності в аптеках та аналогів.
Працює одразу в чотирьох режимах:

1. **Мобільний веб-інтерфейс (PWA)** — відкривається на `/` із будь-якого телефона, можна додати на екран «Додому».
2. **REST API (`FastAPI`)** — `/api/v1/search`, `/api/v1/offers`, `/api/v1/analogues`, Swagger на `/docs`.
3. **Telegram-бот (`aiogram 3`)** — пошук ліків і цін прямо в чаті (`python -m app.bot`).
4. **MCP-сервер (`FastMCP`)** — підключення до ШІ-асистентів (`python -m app.mcp_server`).

## Швидкий деплой із телефона (без ПК)

1. Розпакуйте архів і завантажте файли в новий репозиторій на GitHub.
2. Відкрийте **Render** (для безкоштовного HTTP-режиму — підхопить `render.yaml` і легкий `Dockerfile`) або **Railway** (підхопить `railway.json` і `Dockerfile.playwright` із браузером).
3. Підключіть репозиторій — за 2–3 хвилини отримаєте HTTPS-адресу.
4. Відкрийте її в Safari / Chrome на телефоні → «Поділитися» → «На екран «Додому»».

## Локальний запуск

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env

# API + мобільна вебсторінка (http://localhost:8000)
uvicorn app.main:app --reload --port 8000

# Окремо Telegram-бот (потрібен TABLETKI_TELEGRAM_BOT_TOKEN у .env)
python -m app.bot

# Окремо MCP-сервер
python -m app.mcp_server
```

## Запуск у Docker

```bash
# Лише API + PWA
docker compose up --build -d

# API + PWA + Telegram-бот
docker compose --profile bot up --build -d
```

## Тести

```bash
python -m unittest discover -s tests -v
```

## Оновлення селекторів

Якщо верстка сайту зміниться, достатньо оновити CSS-селектори у файлі `app/selectors.json`.

## Пошук на Render (Serper)

Прямі запити до tabletki.ua з Render блокує Cloudflare. На продакшені конектор використовує [Serper](https://serper.dev) (пошук Google) і читає результати з `site:tabletki.ua`.

1. Створіть ключ на https://serper.dev.
2. У Render (Dashboard → Environment) додайте секрет `TABLETKI_SERPER_API_KEY`. У `render.yaml` це поле з `sync: false`, тож ключ треба ввести вручну і не комітити його в Git.
3. Без ключа API і MCP повернуть явну помилку, що `TABLETKI_SERPER_API_KEY` не задано; локально без ключа лишається прямий запит до tabletki.ua.

