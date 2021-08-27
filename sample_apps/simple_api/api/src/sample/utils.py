
from dateutil.parser import parse as parse_datetime
from datetime import datetime

tests = [
    # (Type, Test)
    (int, int),
    (float, float),
    (datetime, lambda value: parse_datetime(value))
]

def getType(value):
     for typ, test in tests:
         try:
             test(value)
             return typ
         except ValueError:
             continue
     # No match
     return str

   