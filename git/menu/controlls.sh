# ===============================================
# Контрольные тесты
#------------------------------------------------

# GIT PUSH
# Включить SAFE MODE
# echo SAFE > ~/scripts/git-security/git/state/mode
echo SAFE > ~/.git-security/state/mode

# Выключить SAFE MODE
# echo OPEN > ~/scripts/git-security/git/state/mode
echo OPEN > ~/.git-security/state/mode

# Проверка
# cat ~/scripts/git-security/git/state/mode
cat ~/.git-security/state/mode

# Test
# Включаем SAFE
# echo SAFE > ~/scripts/git-security/git/state/mode
echo SAFE > ~/.git-security/git/state/mode

# Пробуем push
git push

# Ожидаемый результат
[SECURITY] git push is BLOCKED (SAFE MODE enabled)
error: failed to push some refs

# Выключаем SAFE
echo OPEN > ~/scripts/git-security/git/state/mode

# GIT FETCH
# SAFE MODE
echo SAFE > ~/scripts/git-security/git/state/mode

# Пробуем fetch
git fetch
# или
git fetch --all --verbose

# Ожидаемо:
[SECURITY] git fetch / pull is BLOCKED (SAFE MODE enabled)
fatal: fetch aborted by hook

# Пробуем pull
git pull
# Возможен эффект «pull ничего не делал»
# То есть: Уже актуально. 
# может быть когда pull не выходил в сеть.

# Ожидаемо:
[SECURITY] git fetch / pull is BLOCKED (SAFE MODE enabled)

# OPEN MODE
echo OPEN > ~/scripts/git-security/git/state/mode

# Пробуем и ожидание работает штатно
git fetch
git pull

# Проверка пути
cat ~/scripts/git-security/git/state/mode

# Ожидаемо
SAFE

# Видит ли GIT pre-fetch ?
nano ~/scripts/git-security/git/hooks/pre-fetch

