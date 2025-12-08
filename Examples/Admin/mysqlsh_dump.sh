#!/bin/bash

/usr/bin/mysqlsh \
    --defaults-file="~/.my.cnf" \
    --file="dump.js"
