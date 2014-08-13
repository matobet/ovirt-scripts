#!/usr/bin/bash

FILE=$SCRIPTS_DIR/engine.answer

if [ ! -f $FILE ]; then
  echo "Error: Answer file $FILE does not exist."
  exit 1
fi
echo "Using answer file $FILE:"
cat $FILE
yes Yes | $PREFIX/bin/engine-setup --config=$FILE &&
psql -U engine -c "update vdc_options set option_value='a' where option_name='AdminPassword'"
