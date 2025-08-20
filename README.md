# NeoVim Configuration with AI Assistant

Полная конфигурация NeoVim с AI-ассистентом (avante.nvim) для разработки на Node.js через OpenRouter API.


## Возможности

- 🤖 **AI-ассистент** - avante.nvim с поддержкой OpenRouter
- 🔧 **LSP поддержка** - TypeScript, JavaScript, JSON, HTML, CSS
- 📝 **Автодополнение** - nvim-cmp с LSP интеграцией
- 🌳 **Подсветка синтаксиса** - Treesitter
- 📁 **Файловый менеджер** - nvim-tree
- 🔍 **Поиск файлов** - Telescope
- 🔀 **Git интеграция** - Gitsigns
- 📊 **Статусная строка** - Lualine
- 🎨 **Тема** - Tokyo Night


## Требования

- Ubuntu 24.04 LTS (или совместимая система)
- Git
- Node.js LTS
- Rust (для компиляции avante.nvim)
- OpenRouter API ключ


## Структура проекта

```
.config/
└── nvim/
    ├── init.lua                 # Основная конфигурация
    └── lua/
        ├── config/
        │   └── lazy.lua         # Менеджер плагинов
        └── plugins/
            ├── avante.lua       # AI-ассистент
            ├── lsp.lua          # LSP конфигурация
            ├── cmp.lua          # Автодополнение
            ├── treesitter.lua   # Подсветка синтаксиса
            ├── nvim-tree.lua    # Файловый менеджер
            ├── telescope.lua    # Поиск
            ├── gitsigns.lua     # Git интеграция
            └── lualine.lua      # Статусная строка
```


## Начало

### 1. Клонирование репозитория

```bash
git clone <your-repo-url> ~/neovim-config
cd ~/neovim-config
```

### 2. Настройка API ключа

```bash
echo 'export OPENAI_API_KEY="your_openrouter_api_key"' >> ~/.bashrc
source ~/.bashrc
```
**Замените `your_openrouter_api_key` на ваш реальный API ключ от OpenRouter!**


## Быстрая установка

### 1. Запуск скрипта установки

```bash
chmod +x install.sh
./install.sh
```

### 2. Первый запуск

```bash
nvim
```
При первом запуске плагины установятся автоматически.


## Ручная установка

### 1: Обновление системы

```bash
sudo apt update && sudo apt upgrade -y
```

### 2: Установка зависимостей

```bash
sudo apt install -y curl wget git build-essential unzip software-properties-common
```

### 3: Установка Node.js

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 4: Установка NeoVim

```bash
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -xzf nvim-linux-x86_64.tar.gz -C /opt/
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

### 5: Установка Rust - нужен для avante.nvim

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
```

### 6: Установка LSP серверов

```bash
npm install -g typescript-language-server @vtsls/language-server eslint_d prettier
```

### 7: Копирование конфигурации

```bash
cp -r .config ~/.config
```

### 8. Первый запуск

```bash
nvim
```
При первом запуске плагины установятся автоматически.


## Горячие клавиши

### AI Assistant (Avante)
- `<Space>aa` - Задать вопрос AI
- `<Space>at` - Переключить боковую панель AI
- `<Space>ar` - Обновить AI
- `<Space>ae` - Редактировать с AI
- `:AvanteAsk` - Команда для вопроса AI

### LSP
- `gd` - Перейти к определению
- `K` - Показать документацию
- `<Space>vca` - Действия кода
- `<Space>vrn` - Переименовать
- `<Space>f` - Форматировать код
- `[d` / `]d` - Навигация по ошибкам

### Файловый менеджер
- `<Space>e` - Переключить файловый менеджер

### Поиск (Telescope)
- `<Space>ff` - Найти файлы
- `<Space>fg` - Поиск по содержимому
- `<Space>fb` - Найти буферы
- `<Space>fh` - Справка

### Общие
- `<Space>` - Leader клавиша
- `<C-d>` / `<C-u>` - Прокрутка с центрированием
- `J` / `K` (в визуальном режиме) - Перемещение строк


