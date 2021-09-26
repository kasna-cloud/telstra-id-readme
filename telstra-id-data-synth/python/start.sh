#!/bin/bash
python3 ./python/australian-cdr-generator.py & python3 ./python/international-cdr-generator.py & python3 ./python/alarm-generator.py & python3 ./python/celltower-generator.py