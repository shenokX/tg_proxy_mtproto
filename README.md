# Готовые бесплатные прокси

🔗 Сервер 1
https://t.me/proxy?server=95.164.123.67&port=443&secret=84233ff8eb08bcb8c5aaffb098989868

🔗 Сервер 2
https://t.me/proxy?server=109.248.59.21&port=443&secret=9ec19eefc050d32821c45633d6c81407


# tg_proxy_mtproto

Готовая сборка MTProxy для Telegram в Docker под Ubuntu.

Проект запускает официальный `MTProxy` в контейнере, использует внешний `.env` для настройки и подходит для быстрого развёртывания на VPS.

## Возможности

- запуск MTProxy в Docker
- настройка через `.env`
- поддержка `ad tag` от `@MTProxybot`
- автоматическая загрузка `proxy-secret` и `proxy-multi.conf`
- простой запуск на Ubuntu/VPS

## Состав проекта

- `Dockerfile` — сборка контейнера
- `docker-compose.yml` — запуск сервиса
- `entrypoint.sh` — подготовка конфигов и старт MTProxy
- `mtproxy.env.example` — пример конфигурации
- `README.md` — инструкция

## Требования

- Ubuntu 20.04 / 22.04 / 24.04
- Docker
- Docker Compose plugin

## Установка Docker

```bash
sudo curl -fsSL https://get.docker.com | sh
```

Проверка:

```bash
docker --version
docker compose version
```

## Установка проекта

Распакуй архив или склонируй репозиторий, затем перейди в папку проекта.

Создай рабочий конфиг:

```bash
cp mtproxy.env.example mtproxy.env
```

Открой и заполни его:

```bash
nano mtproxy.env
```

## Настройка `mtproxy.env`

Пример:

```env
PUBLIC_HOST=YOUR_SERVER_IP
MTPROXY_PORT=443
MTPROXY_STATS_PORT=8888
MTPROXY_WORKERS=2
MTPROXY_SECRET=YOUR_SECRET
MTPROXY_ADTAG=
MTPROXY_TLS_DOMAIN=
MTPROXY_NAT_IP=
MTPROXY_EXTRA_ARGS=
```

### Описание параметров

- `PUBLIC_HOST` — публичный IP сервера
- `MTPROXY_PORT` — порт MTProxy
- `MTPROXY_STATS_PORT` — локальный stats-порт
- `MTPROXY_WORKERS` — количество воркеров
- `MTPROXY_SECRET` — секрет прокси
- `MTPROXY_ADTAG` — тег от `@MTProxybot`
- `MTPROXY_TLS_DOMAIN` — домен для TLS-режима, если используешь
- `MTPROXY_NAT_IP` — NAT IP, если нужен
- `MTPROXY_EXTRA_ARGS` — дополнительные аргументы запуска

## Генерация секрета

Сгенерировать секрет можно так:

```bash
head -c 16 /dev/urandom | xxd -ps -c 32
```

Пример результата:

```text
12333ff8eb08bcb8c5aaffb098989432
```

Вставь его в `mtproxy.env`:

```env
MTPROXY_SECRET=12333ff8eb08bcb8c5aaffb098989432
```

## Запуск

```bash
docker compose up -d --build
```

Проверка логов:

```bash
docker compose logs -f
```

## Подключение в Telegram

После запуска используй ссылку такого вида:

```text
https://t.me/proxy?server=YOUR_SERVER_IP&port=443&secret=YOUR_SECRET
```

Пример:

```text
https://t.me/proxy?server=1.2.3.4&port=443&secret=12333ff8eb08bcb8c5aaffb098989432
```


## Как добавить тег канала

Тег берётся через `@MTProxybot`.

Дальше его нужно вставить в:

```env
MTPROXY_ADTAG=YOUR_ADTAG
```

После изменения конфига пересоздай контейнер:

```bash
docker compose down
docker compose up -d --build --force-recreate
```

## Полезные команды

### Логи

```bash
docker compose logs -f
```

### Перезапуск

```bash
docker compose down
docker compose up -d --build --force-recreate
```

### Проверка переменных внутри контейнера

```bash
docker exec -it mtproxy sh -lc 'env | grep MTPROXY'
```
