# git-security

Набор скриптов для безопасного управления Git и контроля доступа к сети при работе с репозиториями.

## Описание

`GIT-SECURITY` помогает:

- Проверять состояние сети.
- Включать или отключать сеть, изменять пароль при необходимости в аварийном режиме.
- Регистрировать действия, связанные с безопасностью.

## Операционные скрипты сетевой безопасности

- `bin/panic.sh` — управляет включением и выключением сети, а также изменением паролей для режима паники (аварийное завершение работы).
- `bin/network-pause.sh` — центральный контроллер паузы сети.
- `bin/net-status.sh` — состояние сети.
- `bin/burn-zip-archives.sh` — запись ZIP-архивов на CD/DVD.
- `bin/menu.sh` — меню управления GIT-SECURITY.

## Скрипты Git-brandmauer

- `bin/git` - обертка для тестирования git pull и git fetch
- `hooks/common.sh` - скрипт определения режима
- `hooks/enable_hooks.sh` - ручная настройка
- `hooks/pre-fetch` - триггер хука git fetch
- `hooks/pre-push` - триггер хука git push
- `hook/pre-rebase` - триггер хука git rebase
- `state/mode` - данные о состоянии
- `menu/controlls.sh` - команды для тестирования

## Зависимости

`git-security` использует общие функции из библиотеки [`shared-lib`](https://github.com/krashevski/shared-lib).  
Для работы проекта необходимо подключить `shared-lib` в каталог `lib/shared-lib`.

### Установка `shared-lib` через сабмодуль

Если вы клонируете проект впервые:

```bash
git clone --recurse-submodules https://github.com/krashevski/git-security.git
```

## Установка git-security

1. Клонируйте репозиторий:

```bash
git clone https://github.com/krashevski/git_security.git
```

2. Перейдите в каталог проекта:
```bash
cd git_security
```

3. Предоставьте скриптам права на выполнение:
```bash
chmod +x *.sh
```

## Использование

Запустите основной скрипт:
```bash
./bin/menu.sh
```
Логи создаются в каталоге ./logs.

## Примечания

* Скрипты были протестированы в домашней среде (~/.scripts/git_security).

* Также можно использовать в тестовом режиме, изменив пути к логам и статус.

## Лицензия

MIT

## Автор

Владислав Крашевский поддержка ChatGPT
