#!/bin/bash

echo "Перед началом работы скрипта Вам нужно получить 'Personal Access Token', создать готовый репозиторий на GitHub, инициализировать проект в нужной папке на вашем ПК."

read -p "Введите комментарий для будущего коммита: " my_commit

read -p "Введите главную ветку, где находится проект: " main_branch

git add ./*
git commit -m "$my_commit"
git push origin $main_branch
