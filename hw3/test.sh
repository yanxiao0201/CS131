#!/bin/sh
echo "Test: bash test.sh threads = $1  transitions =$2"

java="java"



echo "GetNSet test: "
for i in {1..5}

do
    $java UnsafeMemory GetNSet $1 $2 100 50 60 30 20 30 | grep -Eow "[0-9.]+" | tr '\n' ' '
    echo ""
done

echo "BetterSafe test: "
for i in {1..5}

do
    $java UnsafeMemory BetterSafe $1 $2 100 50 60 30 20 30 | grep -Eow "[0-9.]+" | tr '\n' ' '
    echo ""
done

echo "Synchronized test: "
for i in {1..5}

do
    $java UnsafeMemory Synchronized $1 $2 100 50 60 30 20 30 | grep -Eow "[0-9.]+" | tr '\n' ' '
    echo ""
done

echo "Null test: "
for i in {1..5}

do
    $java UnsafeMemory Null $1 $2 100 5 6 3 0 3 | grep -Eow "[0-9.]+" | tr '\n' ' '
    echo ""
done
