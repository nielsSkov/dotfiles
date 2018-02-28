#
# ~/.bashrc
#

#fix java for matlab 
wmname LG3D 2>/dev/null
# if any probles with any java arises, try adding the following
# (the options can also possibly be set in .xinitrc)
#export _JAVA_AWT_WM_NONREPARENTING=1 &

#fix OpenGL issue
export LIBGL_DRI3_DISABLE=1 &

(wal -rt &)
export LC_ALL=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
