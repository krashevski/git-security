
# Ручная настройка

# mkdir -p "$HOME/scripts/git-security/git/{hooks,state}"
mkdir -p "$HOME/.git-security/{hooks,state}"

# "$HOME/scripts/git-security$ git config --global core.hooksPath ~/scripts/git-security/git/hooks"
cd "$HOME/.git-security"$ git config --global core.hooksPath ~/.git-security/hooks

# Проверка
git config --global core.hooksPath

# Ожидаемо
# "$HOME/scripts/git-security/git/hooks
"$HOME/.git-security/git/hooks