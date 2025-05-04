#!/bin/bash

# Linux/Ubuntu-themed words
linux_words=("ubuntu" "kernel" "bash" "terminal" "root" "sudo" "gnome" "grub" "systemd" "shell" "debian" "fedora" "cron" "ls" "chmod")

answer=""
question=""
num_attempts=6
letters=()

hangman_art=(
"
   +---+
   |   |
       |
       |
       |
       |
=========
"
"
   +---+
   |   |
   O   |
       |
       |
       |
=========
"
"
   +---+
   |   |
   O   |
   |   |
       |
       |
=========
"
"
   +---+
   |   |
   O   |
  /|   |
       |
       |
=========
"
"
   +---+
   |   |
   O   |
  /|\\  |
       |
       |
=========
"
"
   +---+
   |   |
   O   |
  /|\\  |
  /    |
       |
=========
"
"
   +---+
   |   |
   O   |
  /|\\  |
  / \\  |
       |
=========
"
)

add_user() {
    read -p "Enter username to add: " username
    sudo adduser "$username"
}

delete_user() {
    read -p "Enter username to delete: " username
    sudo deluser "$username"
}

modify_user() {
    read -p "Enter existing username: " oldname
    echo "1. Change username"
    echo "2. Change password"
    read -p "Choose an option: " opt
    if [[ "$opt" == "1" ]]; then
        read -p "Enter new username: " newname
        sudo usermod -l "$newname" "$oldname"
    elif [[ "$opt" == "2" ]]; then
        sudo passwd "$oldname"
    else
        echo "Invalid option"
    fi
    sleep 2
}

list_users() {
    echo -e "\nSystem users:"
    cut -d: -f1 /etc/passwd
    echo
    read -p "Press enter to return to menu..."
}

print_hangman() {
    local idx=$((6 - num_attempts))
    echo "${hangman_art[$idx]}"
}

print_question() {
    print_hangman
    echo -e "\nWord: $question"
    echo "Attempts left: $num_attempts"
    echo "Guessed letters: ${letters[*]}"
}

generate_question() {
    answer="${linux_words[$RANDOM % ${#linux_words[@]}]}"
    question=""
    for (( i=0; i<${#answer}; i++ )); do
        question+="_"
    done
}

update_question() {
    local guess="$1"
    local updated=""
    for (( i=0; i<${#answer}; i++ )); do
        if [[ "${answer:$i:1}" == "$guess" ]]; then
            updated+="$guess"
        else
            updated+="${question:$i:1}"
        fi
    done
    question="$updated"
}

play_hangman() {
    clear
    echo "=== Welcome to Linux Hangman ==="
    answer="${linux_words[$RANDOM % ${#linux_words[@]}]}"
    generate_question
    letters=()
    num_attempts=6

    while [[ "$question" != "$answer" && $num_attempts -gt 0 ]]; do
        print_question
        read -p "Guess a letter: " guess
        guess="${guess,,}"  # lowercase
        if [[ ! "$guess" =~ ^[a-z]$ ]]; then
            echo "Enter a single letter!"
            continue
        fi
        if [[ "${letters[*]}" =~ "$guess" ]]; then
            echo "Already guessed!"
            continue
        fi
        letters+=("$guess")

        if [[ "$answer" == *"$guess"* ]]; then
            update_question "$guess"
        else
            ((num_attempts--))
        fi
    done

    print_hangman
    if [[ "$question" == "$answer" ]]; then
        echo -e "\n🎉 You guessed it! The word was '$answer'."
    else
        echo -e "\n💀 Game Over! The word was '$answer'."
    fi
    echo
    read -p "Press enter to return to menu..."
}

main_menu() {
    while true; do
        clear
        echo "=== Linux Admin Hangman Menu ==="
        echo "1. Play Hangman"
        echo "2. Add User"
        echo "3. Delete User"
        echo "4. Modify Existing User"
        echo "5. List All Users"
        echo "6. Exit"
        read -p "Choose an option: " choice
        case "$choice" in
            1) play_hangman ;;
            2) add_user ;;
            3) delete_user ;;
            4) modify_user ;;
            5) list_users ;;
            6) echo "Goodbye!"; exit ;;
            *) echo "Invalid choice"; sleep 1 ;;
        esac
    done
}

main_menu
