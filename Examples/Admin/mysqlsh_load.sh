#!/bin/bash

mysqlsh \
    --defaults-file="~/.my.cnf" \
    --file="load.js"
