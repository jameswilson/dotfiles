#!/usr/bin/env sh
#echo ~/.profile
# Add XDG Base Directory Specification to MacOs
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$(getconf DARWIN_USER_CACHE_DIR)}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$(getconf DARWIN_USER_TEMP_DIR)}"

# Helper function allows safely modifying $PATH environment variable.
function pathmunge() {
  case ":${PATH}:" in
    # Do not add the same path twice.
    *:"$1":*)
      ;;
    *)
      if [ "$2" = "after" ] ; then
        # Append to $PATH.
        PATH=$PATH:$1
      else
        # Prepend to $PATH.
        PATH=$1:$PATH
      fi
  esac
}

source ~/.environment
source ~/.aliases
source ~/.git-safe-force-push.sh
source ~/.git-prompt.sh
