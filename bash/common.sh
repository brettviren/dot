# -*- shell-script -*- #

# Meta-settings and functions common to all other bash setup scripts

export DOT_BASE=~/dot/bash

# Source all files in a given directory
dot_sourcedir () {
    local dir=$1 ; shift
    if [ ! -d $dir ] ; then
	#echo "dot_sourcedir: given non-directory: $dir"
	return
    fi
    # avoid *~ and .*
    local file
    for file in $dir/*[a-zA-Z0-9] ; do
	if [ -d $file ] ; then continue; fi
	if [ ! -f $file ] ; then continue; fi
	source $file
    done
}
dot_source_dirs () {
    local subdir=$1 ; shift
    local basedir=$DOT_BASE/$subdir
    if [ ! -d $basedir ] ; then
	#echo "dot_source_dirs: given non-directory: $basedir"
	return
    fi
    # Kernel, distributor, distribution codename, domainname, hostname
    local dirs="all"
    dirs+=" $(uname -s) $(lsb_release -s -i) $(lsb_release -s -c)"
    dirs+=" $(hostname -d) $(uname -n)"
    for dir in $dirs; do
	dot_sourcedir $basedir/$dir
    done

    local local_file
    if [ "$subdir" = "rc" ] ; then
	local_file=$HOME/.bashrc.local
    else
	local_file=$HOME/.bash_${subdir}.local
    fi
    if [ -f $local_file ] ; then source $local_file; fi
}
dot_sourcedir $DOT_BASE/common
