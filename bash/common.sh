# -*- shell-script -*- #

# Meta-settings and functions common to all other bash setup scripts

export DOT_BASE=~/dot/bash

# Source all files in a given directory
dot_sourcedir () {
    dir=$1 ; shift
    if [ ! -d $dir ] ; then
	#echo "dot_sourcedir: given non-directory: $dir"
	return
    fi
    # avoid *~ and .*
    for file in $dir/*[a-zA-Z0-9] ; do
	if [ -d $file ] ; then continue; fi
	if [ ! -f $file ] ; then continue; fi
	source $file
    done
}
dot_source_dirs () {
    subdir=$1 ; shift
    basedir=$DOT_BASE/$subdir
    if [ ! -d $basedir ] ; then
	echo "dot_source_dirs: given non-directory: $basedir"
	return
    fi
    # Kernel, distributor, distribution codename, hostname
    dirs="all $(uname -s) $(lsb_release -s -i) $(lsb_release -s -c) $(uname -n)"
    for dir in $dirs; do
	dot_sourcedir $basedir/$dir
    done

    if [ "$subdir" = "rc" ] ; then
	local_file=$HOME/.bashrc.local
    else
	local_file=$HOME/.bash_${subdir}.local
    fi
    if [ -f $local_file ] ; then source $local_file; fi
}
dot_sourcedir $DOT_BASE/common
