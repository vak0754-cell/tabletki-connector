FROM python:3.12-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends libxml2 libxslt1.1 \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# app.tar.gz contains the app/ package; ADD auto-extracts it into /app
ADD app.tar.gz /app/
RUN mkdir -p /app/data
ENV TABLETKI_CACHE_DB_PATH=/app/data/cache.sqlite3
ENV TABLETKI_ENABLE_PLAYWRIGHT_FALLBACK=false
ENV PORT=8000
EXPOSE 8000
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
