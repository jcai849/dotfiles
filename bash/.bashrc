alias what-todo='head -1 $(find ~ -name TODO)'
alias wordcount='echo $(($(cat $(ls *.txt) | wc -w) + $(detex $(ls *.tex) | wc -w)))'
alias 2fa='oathtool --totp --base32 "$(< ~/.2facode)"'
