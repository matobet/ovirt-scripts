#!/usr/bin/bash

FILE=$SCRIPTS_DIR/engine.answer

if [ ! -f $FILE ]; then
  echo "Error: Answer file $FILE does not exist."
  exit 1
fi
echo "Using answer file $FILE:"
cat $FILE
yes | $PREFIX/bin/engine-setup --config=$FILE
