#!/bin/bash

# sources in ~/.bashrc

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "source $DIR/chech.sh" >> ~/.bashrc
