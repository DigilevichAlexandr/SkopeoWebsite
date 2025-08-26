# Используем официальный образ .NET 8 SDK для сборки
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Копируем файл проекта и восстанавливаем зависимости
COPY SkopeoWebsite.csproj .
RUN dotnet restore

# Копируем весь исходный код
COPY . .

# Собираем приложение
RUN dotnet publish -c Release -o /app/publish --no-restore

# Используем nginx для статического контента
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html

# Копируем собранное приложение
COPY --from=build /app/publish/wwwroot .

# Копируем конфигурацию nginx для SPA
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
