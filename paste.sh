#!/bin/bash
ORIGIN=$(dirname $(readlink -f $0))
npx iced $ORIGIN/module.iced $@

