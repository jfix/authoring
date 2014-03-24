#!/bin/sh

OECDROOT=/Users/nicg/Projects/OECD

SCRIPT=$OECDROOT/authoring/tools/quality-assurance/framework/xproc/process-test-manifest.xpl

CONFIG=`path-to-uri /Users/nicg/Projects/OECD/authoring/tools/quality-assurance/framework/configs/schema-manifest.xml`

MANIFEST=`path-to-uri $1`
OUTPUT=`path-to-uri $2`

echo Processing $MANIFEST to $OUTPUT

calabash --input manifest=$MANIFEST --input config=$CONFIG $SCRIPT output-base-uri=$OUTPUT
