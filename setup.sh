#!/usr/bin/bash

FILE=$HOME/ovirt-scripts/engine.answer

if [ ! -f $FILE ]; then
  echo "Error: Answer file $FILE does not exist."
  exit 1
fi
echo "Using answer file $FILE:"
cat $FILE
echo -e "yes\nyes" | $PREFIX/bin/engine-setup --config=$FILE
