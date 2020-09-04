#! /bin/sh
if [ $# -ne 1 ]; then
  echo "Wrong number of parameters."
  exit 1
fi

cpp -P $1 | ./lvm
