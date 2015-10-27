#!/bin/bash

NAME=ChatTabs
CFGNAME=ChatTabs
RCC=${HOME}/Qt/5.5/clang_64/bin/rcc
SRC=../Source/
OUTPUT=./Deploy

mkdir -p $OUTPUT

cp $SRC/$CFGNAME.cfg $OUTPUT
$RCC -threshold 70 -binary -o $OUTPUT/$NAME.rcc $SRC/$NAME.qrc