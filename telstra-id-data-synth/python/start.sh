#!/bin/bash
cd /app/python
python3 ./australian-cdr-generator.py & python3 ./international-cdr-generator.py & python3 ./alarm-generator.py & python3 ./celltower-generator.py & python3 ./faults-generator.py