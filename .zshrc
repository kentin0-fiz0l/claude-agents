export PATH="/opt/homebrew/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kentino/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kentino/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kentino/miniconda3/etc/profile.d/conda.sh"
    else
export PATH="/Users/kentino/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.local/bin:$PATH"
# export OPENAI_API_KY=
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
alias md5sum="md5 -r"
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v17)
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# ComfyUI / PyTorch MPS (Apple Silicon) settings
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0
export PYTORCH_ENABLE_MPS_FALLBACK=1

# Claude Code - Default model for new sessions
export ANTHROPIC_DEFAULT_MODEL="claude-sonnet-4-5"

# GitHub token for MCP server (get from gh CLI)
export GITHUB_TOKEN="$(gh auth token 2>/dev/null || echo '')"

# fal.ai API
export FAL_KEY="6d138710-beca-4e63-97ad-86295be404be:86bb0aa675179d12c7b6a5c40158901b"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kentino/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kentino/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kentino/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kentino/google-cloud-sdk/completion.zsh.inc'; fi
