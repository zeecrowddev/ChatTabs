#!/bin/bash

NAME=ChatTabs
CFGNAME=ChatTabs
RCC=${HOME}/Qt5.3.2/5.3/clang_64/bin/rcc
SRC=../Source/
OUTPUT=./Deploy

mkdir -p $OUTPUT

cp $SRC/$CFGNAME.cfg $OUTPUT
$RCC -threshold 70 -binary -o $OUTPUT/$NAME.rcc $SRC/$NAME.qrc