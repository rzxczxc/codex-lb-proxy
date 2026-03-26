# Используем оригинальный образ как базу
FROM ghcr.io/soju06/codex-lb:latest

# Устанавливаем proxychains4 от имени root
USER root
RUN apt-get update && apt-get install -y proxychains4 && rm -rf /var/lib/apt/lists/*

# Возвращаемся к пользователю приложения (если он был определен в базе)
# Если в оригинале используется root, эту строку можно пропустить
USER app

# Переопределяем команду запуска, пробрасывая её через proxychains

ENTRYPOINT ["proxychains4", "-f", "/etc/proxychains4.conf"]
CMD ["/app/scripts/docker-entrypoint.sh"]