#!/bin/bash
export sample_SECRET='something-really-secret' 
export FLASK_APP=autoapp.py
flask db init
flask db migrate
flask db upgrade
sleep 60
flask seed data/data.json 