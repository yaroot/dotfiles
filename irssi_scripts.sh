#!/bin/sh

mkdir -p $HOME/.irssi/scripts/autorun

pushd $HOME/.irssi > /dev/null

if [ -d '_source' ]; then
    pushd _source > /dev/null
    git fetch
    git feset --hard origin/gh-pages
    popd > /dev/null
else
    git clone git://github.com/irssi/scripts.irssi.org.git _source
fi

link() {
    ln -sv ../_source/scripts/$1 .
}

pushd scripts/autorun > /dev/null

if [ `pwd` = "$HOME/.irssi/scripts/autorun" ]; then
    rm *.pl
fi

link 'dispatch.pl'
link 'nickcolor.pl'
link 'nicklist.pl'
link 'splitlong.pl'
link 'usercount.pl'

