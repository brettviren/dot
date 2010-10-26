#!/bin/bash

install_file () {
    source=$1 ; shift
    target=$1 ; shift
    if [ -z "$source" -o -z "$target" ] ; then 
	echo "install_file <source> <target>"
	return
    fi
    if [ ! -f $source ] ; then
	echo "File to install d.n.e.: $source"
	return
    fi

    if [ -f $target ] ; then
	if [ -L $target ] ; then
	    echo "Removing link: $target"
	    rm -f $target
	else
	    mv $target{,.moved}
	    echo "Previous $target moved to $target.moved"
	fi
    fi
    echo "Linking $source -> $target"
    ln -sf $source $target
}

install_bash () {
    install_file $HOME/dot/bash/bash_login $HOME/.bash_login
    install_file $HOME/dot/bash/bash_logout $HOME/.bash_logout
    install_file $HOME/dot/bash/bashrc $HOME/.bashrc
    for file in $HOME/.profile $HOME/.bash_profile; do
	if [ ! -f $file ] ; then continue; fi
	echo "Moving $file to ${file}.moved"
	mv $file{,.moved}
    done
}

install_emacs () {
    line='setq custom-file'
    if grep -q $line $HOME/.emacs ; then
	return
    fi
    install_file $HOME/dot/emacs/dot.emacs $HOME/.emacs
}

install_bash
install_emacs
