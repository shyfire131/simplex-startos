#!/bin/bash

output=$(nc -zv 127.0.0.1 5223 2>&1)

expected_output="Connection to 127.0.0.1 5223 port [tcp/*] succeeded!"

if [ "$output" == "$expected_output" ]; then
    exit 0
else
    echo "Error: smp-server does not seem to be responding to connection requests"
    exit 1
fi