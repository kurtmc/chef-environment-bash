# This config relies on the following functions being defined
# chef-show
# chef-local
# chef-prod

SHELL_PROMPT=true

if [ "$SHELL_PROMPT" == "true" ]; then
	export PS1="\u@\h \w\[$(tput sgr0)\]"
	update_prompt() {
		if [ "$(chef-show)" == "local" ]; then
			export PS1="\[\033[38;5;10m\]$(chef-show)\[$(tput sgr0)\]\[\033[38;5;15m\] \W\[$(tput sgr0)\] "
		elif [ "$(chef-show)" == "prod" ]; then
			export PS1="\[\033[38;5;9m\]$(chef-show)\[$(tput sgr0)\]\[\033[38;5;15m\] \W\[$(tput sgr0)\] "
		fi
	}
	export PROMPT_COMMAND="update_prompt"
fi


preexec() {
	if [[ $1 == chef-local* ]]; then
		shopt -u extdebug
		return
	fi

	if [ "$(chef-show)" == "prod" ]; then
		shopt -s extdebug
		echo "Do you actually want to run \"$1\" in production?"
		read response
		if [ "$response" == "yes" ]; then
			echo "Executing in prod"
		else
			echo "Command cancelled"
			return 1
		fi
	fi
	
}
preexec_invoke_exec () {
	[ -n "$COMP_LINE" ] && return  # do nothing if completing
	[ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
	local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
	preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG
