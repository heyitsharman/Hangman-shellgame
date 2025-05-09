#!/bin/bash

# Linux/Ubuntu-themed words

linux\_words=("ubuntu" "kernel" "bash" "terminal" "root" "sudo" "gnome" "grub" "systemd" "shell" "debian" "fedora" "cron" "ls" "chmod")

answer=""
question=""
num\_attempts=6
letters=()

# Menu shown after any task

post\_action\_menu() {
choice=\$(dialog --stdout --menu "What would you like to do next?" 10 40 2&#x20;
1 "Return to Main Menu"&#x20;
2 "Exit to Terminal")

```
case "$choice" in
    1) return ;;
    2) clear; exit ;;
    *) clear; exit ;;
esac
```

}

add\_user() {
username=\$(dialog --stdout --inputbox "Enter username to add:" 8 40)
\[ -z "\$username" ] && return
sudo adduser "\$username"
post\_action\_menu
}

delete\_user() {
username=\$(dialog --stdout --inputbox "Enter username to delete:" 8 40)
\[ -z "\$username" ] && return
sudo deluser "\$username"
post\_action\_menu
}

modify\_user() {
oldname=\$(dialog --stdout --inputbox "Enter existing username:" 8 40)
\[ -z "\$oldname" ] && return
opt=\$(dialog --stdout --menu "What would you like to modify?" 10 40 2&#x20;
1 "Change username"&#x20;
2 "Change password")
case "\$opt" in
1\)
newname=\$(dialog --stdout --inputbox "Enter new username:" 8 40)
\[ -z "\$newname" ] && return
sudo usermod -l "\$newname" "\$oldname"
;;
2\)
sudo passwd "\$oldname"
;;
\*)
dialog --msgbox "Invalid option" 6 30 ;;
esac
post\_action\_menu
}

list\_users() {
cut -d: -f1 /etc/passwd > /tmp/userlist.txt
dialog --textbox /tmp/userlist.txt 20 50
post\_action\_menu
}

generate\_question() {
answer="\${linux\_words\[\$RANDOM % \${#linux\_words\[@]}]}"
question=""
for (( i=0; i<\${#answer}; i++ )); do
question+="\_"
done
letters=()
num\_attempts=6
}

update\_question() {
local guess="\$1"
local updated=""
for (( i=0; i<\${#answer}; i++ )); do
if \[\[ "\${answer:\$i:1}" == "\$guess" ]]; then
updated+="\$guess"
else
updated+="\${question:\$i:1}"
fi
done
question="\$updated"
}

play\_hangman() {
generate\_question
while \[\[ "\$question" != "\$answer" && \$num\_attempts -gt 0 ]]; do
status="Word: \$question\nAttempts left: \$num\_attempts\nGuessed: \${letters\[*]}"
guess=\$(dialog --stdout --inputbox "\$status\n\nEnter a letter:" 12 50)
\[ -z "\$guess" ] && break
guess="\${guess,,}"
if \[\[ ! "\$guess" =\~ ^\[a-z]\$ ]]; then
dialog --msgbox "Enter a single alphabet letter!" 6 40
continue
fi
if \[\[ "\${letters\[*]}" =\~ "\$guess" ]]; then
dialog --msgbox "Already guessed!" 6 30
continue
fi
letters+=("\$guess")
if \[\[ "\$answer" == *"\$guess"* ]]; then
update\_question "\$guess"
else
((num\_attempts--))
fi
done

```
if [[ "$question" == "$answer" ]]; then
    dialog --msgbox "🎉 You guessed it! The word was '$answer'." 6 50
else
    dialog --msgbox "💀 Game Over! The word was '$answer'." 6 50
fi
post_action_menu
```

}

main\_menu() {
while true; do
choice=\$(dialog --stdout --menu "=== Linux Admin Hangman ===" 15 50 6&#x20;
1 "Play Hangman"&#x20;
2 "Add User"&#x20;
3 "Delete User"&#x20;
4 "Modify Existing User"&#x20;
5 "List All Users"&#x20;
6 "Exit")
case "\$choice" in
1\) play\_hangman ;;
2\) add\_user ;;
3\) delete\_user ;;
4\) modify\_user ;;
5\) list\_users ;;
6\) clear; exit ;;
\*) dialog --msgbox "Invalid choice!" 6 30 ;;
esac
done
}

main\_menu
