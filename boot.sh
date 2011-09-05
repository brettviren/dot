#!/bin/bash
#
# Boot a new account configuration.
#
# This is to get just enough for Fabric and git to work.
#
#

# Handle rootification differences between ubuntu and debian
susudo () {
    file=$(mktemp)
    echo '#!/bin/bash' > $file
    echo "$@" >> $file
    chmod +x $file
    if [ "$(lsb_release -is)" = "Ubuntu" ] ; then
	echo 'Provide your password'
	sudo $file
    elif [ "$(lsb_release -is)" = "Debian" ] ; then
	echo 'Provide root password'
	su -c $file root
    else
	echo "Unknown platform"
    fi
    rm -f "$file"
}
	
# Install some system packages
system_packages () {
    susudo apt-get install git python-setuptools python-virtualenv
}

# Initial virtualenv
boot_opt () {
    if [ -d "$HOME/opt" ] ; then
	echo "$HOME/opt already started"
	exit 0
    fi
    virtualenv $HOME/opt
    source $HOME/opt/bin/activate
    easy_install fabric
    deactivate
}

# Get my dot package from github
get_dot () {
    url=git@github.com:brettviren/dot.git

    if [ ! -d "$HOME/git" ] ; then
	mkdir "$HOME/git"
    fi
    cd $HOME/git
    if [ -d "dot" ] ; then
	cd "dot/"
	git fetch
	return
    fi
    git clone $url dot
}


# Hook in shell setup
setup_shell () {
    archive_factory () {
	file=$1 ; shift
	if [ ! -L "$HOME/.$file" ] ; then
	    if [ ! -d "$HOME/.factory" ] ; then
		mkdir "$HOME/.factory"
	    fi
	    mv "$HOME/.$file" .factory
	    echo "Archiving $HOME/.$file"
	fi
    }
    for file in profile bash_login bash_logout bashrc
    do
	archive_factory $file
    done

    for file in bash_login bash_logout bashrc
    do
	ln -s $HOME/git/dot/bash/$file $HOME/.$file
    done
}

main () {
    system_packages
    boot_opt
    get_dot
    setup_shell
}

main
