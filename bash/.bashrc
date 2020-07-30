# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

alias what-todo='head -1 $(find ~ -name TODO)'
alias wordcount='echo $(($(cat $(ls *.txt) | wc -w) + $(detex $(ls *.tex) | wc -w)))'
alias 2fa='oathtool --totp --base32 "$(< ~/.2facode)"'
