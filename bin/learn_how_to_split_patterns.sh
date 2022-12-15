#!/usr/bin/env bash

# Given a filepath with a filename in three parts separated by a hyphen,  and an extension separated by a period,
#   like foo/bar/baz/a-b-c.xxx
# separate out the a, b and c.
# Done here in decreasing order of difficulty, in three ways: bash built-ins, sed then awk


FILENAME=CodeSystem-mondo-3.owl
echo "FILENAME $FILENAME"
all=`basename $FILENAME`
main=${all%.owl}

echo "-bash----"
a=${main%%-*}
remainder=${main##$a-}
b=${remainder%%-*}
remainder=${remainder##$b-}
c=$remainder
echo "$a $b $c"

echo "-sed------"
main=`echo $FILENAME | sed -e 's/.owl//'`
a=`echo $main | sed -e 's/.owl//' | sed -e 's/-[a-zA-Z0-9]*-[a-zA-Z0-9]*//'`
b=`echo $main | sed -e 's/.owl//' | sed -e 's/[a-zA-Z0-9]*-//' | sed -e 's/-[a-zA-Z0-9]*//'`
c=`echo $main | sed -e 's/.owl//' | sed -e 's/[a-zA-Z0-9]*-[a-zA-Z0-9]*-//'`
echo "$a   $b  $c"

echo "-awk-----------"
main=`echo $FILENAME | awk -F. '{print $1}'`
a=`echo $main | awk -F- '{print $1}'`
b=`echo $main | awk -F- '{print $2}'`
c=`echo $main | awk -F- '{print $3}'`
echo "$a   $b  $c"



