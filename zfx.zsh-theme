
### Grayscale Theme ###
CURRENT_BG='NONE'
CURRENT_FG='NONE'

# Special Powerline characters
SEGMENT_SEPARATOR=$'›'

# Begin a segment
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $ != $CURRENT_BG ]]; then
    echo -n " "
  else
    echo -n " "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components ###
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black white "%(!.%{%F{'NONE'}%}.)%n@%m"
  fi
}

prompt_git() {
  (( $+commands[git] )) || return
  local ref dirty mode
  if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    dirty=$(command git status --porcelain 2>/dev/null)
    ref=$(command git symbolic-ref HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)
    if [[ -n $dirty ]]; then
      prompt_segment 'NONE' 'NONE'
    else
      prompt_segment 'NONE' 'NONE'
    fi
    echo -n " ${ref##refs/heads/}"
  fi
}

prompt_dir() {
  prompt_segment darkgray 'NONE' '%~'
}

prompt_status() {
  [[ $RETVAL -ne 0 ]] && prompt_segment black white "⨉"
  [[ $UID -eq 0 ]] && prompt_segment black white "✓"
}

build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '

