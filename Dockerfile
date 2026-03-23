# Используем оригинальный образ как базу
FROM ghcr.io/soju06/codex-lb:latest

# Копируем локальные патчи в образ для применения во время сборки
COPY patches /tmp/patches

# Устанавливаем зависимости сборки от имени root
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends git proxychains4 \
    && find /tmp/patches -type f -name '*.patch' -print | sort | while read -r patch_file; do \
        git apply -p1 --directory=/app --include='app/**' "$patch_file"; \
    done \
    && rm -rf /tmp/patches \
    && rm -rf /var/lib/apt/lists/*

# Возвращаемся к пользователю приложения (если он был определен в базе)
# Если в оригинале используется root, эту строку можно пропустить
USER app

# Переопределяем команду запуска, пробрасывая её через proxychains

ENTRYPOINT ["proxychains4", "-f", "/etc/proxychains4.conf"]
CMD ["/app/scripts/docker-entrypoint.sh"]
