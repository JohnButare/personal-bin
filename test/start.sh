#!/bin/bash
. function.sh

dir="/tmp/a b"
[[ ! -d "$dir" ]] && mkdir "$dir"
echo hi > "$dir/a.txt"
echo hi > "$dir/b.txt"
echo a > "$dir/a.txt"
echo b > "$dir/b.txt"

bc="$P32/Beyond Compare 3/BComp.exe"
set -- "$dir/a.txt" "$dir/b.txt"

# does not start asynchrously
# "$bc" "$@" -- does not load files
"$bc" "$(utw $1)" "$(utw $2)" /title1="\"this is cool\""
"$bc" /?

cygstart "$bc" "$@"

"$bc" /?

# direct start - arguments must be in windows format, does not start async
# "$bc" "$(utw $1)" "$(utw $2)" /title1="this is cool 

# cygstart
# 1) arguments must be in windows format
# 2) starts async
# 3) must quote arguments with \" so the quotes are passed to Windows
# 4) program can be a program, file, or URL
cygstart "$bc" "\"$(utw $1)\"" "\"$(utw $2)\"" "\"/title1="this is cool"\""

# start file using associated program
touch "$dir/a b.docx"
cygstart "$dir/a b.docx"
