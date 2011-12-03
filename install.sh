#!/bin/bash

source $HOME/git/dot/bash/common.sh

install_file () {
    local source=$1 ; shift
    local target=$1 ; shift
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
    install_file $DOT_BASE/bash/bash_login $HOME/.bash_login
    install_file $DOT_BASE/bash/bash_logout $HOME/.bash_logout
    install_file $DOT_BASE/bash/bashrc $HOME/.bashrc
    for file in $HOME/.profile $HOME/.bash_profile; do
	if [ ! -f $file ] ; then continue; fi
	echo "Moving $file to ${file}.moved"
	mv $file{,.moved}
    done
}

install_emacs () {
    if [ -f $HOME/.emacs ] ; then
	local line='setq custom-file'
	if grep -q "$line" $HOME/.emacs ; then
	    return
	fi
    fi
    install_file $DOT_BASE/emacs/dot.emacs $HOME/.emacs
}

install_mail () {
    rc=".offlineimaprc"
    if [ -f $HOME/$rc ] ; then
	return
    fi
    install_file $DOT_BASE/mail/dot$rc $HOME/$rc
}

install_gstm () {
    if [ -d $HOME/.gSTM ] ; then
	mv $HOME/.gSTM $HOME/.gSTM.moved
    fi
    if [ -L $HOME/.gSTM ] ; then
	return
    fi
    ln -s $DOT_BASE/gstm $HOME/.gSTM
}

install_less () {
    install_file $DOT_BASE/less/dot.lessfilter $HOME/.lessfilter
}

install_sawfish () {
    if [ -d $HOME/.sawfish ] ; then
	mv $HOME/.sawfish $HOME/.sawfish.moved
    fi
    ln -s $DOT_BASE/sawfish $HOME/.sawfish
}

install_bash
install_emacs
install_mail
install_gstm
install_less
install_sawfish