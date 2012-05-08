#!/bin/sh

find . \( -name '*.hi' -or -name '*.o' -or -name '*.hc' \) -exec rm {} \;
rm -f hhh
