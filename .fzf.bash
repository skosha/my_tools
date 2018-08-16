# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kshah/.fzf/bin* ]]; then
  export PATH="$PATH:/home/kshah/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kshah/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/kshah/.fzf/shell/key-bindings.bash"
