#!/bin/bash
DIR="./integration_test/output.txt"
cat $DIR
cat 1> ./integration_test/output-temp.txt
cat ./integration_test/output-temp.txt | tr -d '\000' > $DIR
if cat $DIR | grep -q '^Failure Details:'; then
if ! cat $DIR | grep -q '^The value of ErrorWidget.builder was changed by the test.'; then
echo -e '==========================================================='
echo -e '= ERROR DETAILS                                           ='
echo -e '==========================================================='
cat $DIR | grep '^Error'
cat $DIR | grep -A5000 '^Failure Details:'
fi
fi
echo -e '==========================================================='
echo -e '= STEPS                                                   ='
echo -e '==========================================================='
cat $DIR | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep '\"STARTED\"$'
cat $DIR | pcregrep -M  '^@\=@\=.*@\+@\+$' | sed -e 's/\(@=@=,\)//g' | sed -e 's/\(,@+@+\)//g'
cat $DIR | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep -v '\"STARTED\"$' | tail -1 | grep -v '\"Passed\"$' | sed 's/BEFORE/Failed/g'
echo -e '==========================================================='
echo -e '= ERROR SUMMARY                                           ='
echo -e '==========================================================='
cat $DIR | sed -n -e '/^The following TestFailure object was thrown running a test:/,/^When the exception was thrown, this was the stack:$/ p' | grep -v '^When the exception was thrown, this was the stack:$'
if cat $DIR | grep -q -v '^The following TestFailure object was thrown running a test:'; then
cat $DIR | sed -n -e '/^The following TestFailure object was thrown running a test:/,/^When the exception was thrown, this was the stack:$/ p' | grep -v '^When the exception was thrown, this was the stack:$'
fi
if cat $DIR | grep -q -v '^The following StateError was thrown running a test:'; then
cat $DIR | sed -n -e '/^The following StateError was thrown running a test:/,/^When the exception was thrown, this was the stack:$/ p' | grep -v '^When the exception was thrown, this was the stack:$'
fi
