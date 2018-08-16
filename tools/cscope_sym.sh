#!/bin/bash

# Build cscope for mac
if [ $1 -ge 1 ]; then
    rm -rf cscope.*
    find . -name "*.c" -o -name "*.h" -o -name "*.s" -o -name "*.S" -o -name "*.xml" -o -name "*.cpp" | grep -v -e "/huts/" -e "/debug/" -e "/unity/" -e "/arch/" -e "/wlanlite/" > cscope.files
    export TMPDIR=/tmp
    cscope -b
fi

# Build cscope for wlan
if [ $1 -ge 2 ]; then
    pushd ../
    rm -rf cscope.*
    find ./builds -name "*.c" -o -name "*.h" -o -name "*.xml" -o -name "*.cpp" | grep -v -e "/huts/" -e "/debug/" -e "/unity/" -e "/arch/" -e "/wlanlite/" >> cscope.files
    find ./common -name "*.c" -o -name "*.h" -o -name "*.s" -o -name "*.S" -o -name "*.xml" -o -name "*.cpp" | grep -v -e "/huts/" -e "/debug/" -e "/unity/" -e "/arch/" -e "/wlanlite/" >> cscope.files
    export TMPDIR=/tmp
    cscope -b
    popd
fi

# Build cscope for hw regs
if [ $1 -ge 3 ]; then
    pushd ../../../hardware/regs
    rm -rf cscope.*
    find . -name "*.c" -o -name "*.h" -o -name "*.s" -o -name "*.S" -o -name "*.xml" -o -name "*.cpp" > cscope.files
    export TMPDIR=/tmp
    cscope -b
    popd
fi
