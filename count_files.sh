#!/bin/bash

#task2
TARGET_DIR="${1:-/etc}"

# Функція для підрахунку
count_items() {
    local dir=$1
    local type=$2
    find "$dir" -maxdepth 1 -type "$type" 2>/dev/null | wc -l
}

# Підрахунок різних типів
files=$(count_items "$TARGET_DIR" "f")
dirs=$(count_items "$TARGET_DIR" "d")
links=$(count_items "$TARGET_DIR" "l")

# Виведення результатів
echo "Статистика директорії $TARGET_DIR:"
echo "  Звичайні файли: $files"
echo "  Директорії: $((dirs - 1))"  # Віднімаємо саму директорію
echo "  Символічні посилання: $links"
echo "  -------------------------"
echo "  Разом (тільки файли): $files"
echo ""

#task1
EXTENSION="$2"

if [ -n "$EXTENSION" ]; then
    ext_files=$(find "$TARGET_DIR" -maxdepth 1 -type f -name "*.$EXTENSION" 2>/dev/null | wc -l) #додано 2>/dev/null для 3 лаби
    echo "Файлів з розширенням .$EXTENSION: $ext_files"
fi

#task3
all_files=$(find "$TARGET_DIR" -type f 2>/dev/null | wc -l)
echo "Файлів разом з піддиректоріями: $all_files"

#task4
total_size=0

while read file; do
    size=$(stat -c %s "$file" 2>/dev/null)
    total_size=$((total_size + size))
done < <(find "$TARGET_DIR" -type f 2>/dev/null)

echo "Загальний розмір знайдених файлів: $total_size байт"
