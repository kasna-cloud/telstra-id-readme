
.. code-block:: bash

    export sample_SECRET='something-really-secret'

Before running shell commands, set the ``FLASK_APP`` and ``FLASK_DEBUG``
environment variables ::

    export FLASK_APP=autoapp.py
    export FLASK_DEBUG=1

Then run the following commands to bootstrap your environment ::

    pip install -r requirements/dev.txt


Run the following commands to create your app's
database tables and perform the initial migration ::

    flask db init
    flask db migrate
    flask db upgrade

To run the web application use::

    flask run --with-threads


Deployment
----------

In your production environment, make sure the ``FLASK_DEBUG`` environment
variable is unset or is set to ``0``, so that ``ProdConfig`` is used, and
set ``DATABASE_URL`` which is your postgresql URI for example
``postgresql://localhost/example`` (this is set by default in heroku).


Shell
-----

To open the interactive shell, run ::

    flask shell

By default, you will have access to the flask ``app`` and models.



Seed

---------

    flask seed
    

Running as Gunicorn
--------

web: gunicorn autoapp:app -b 0.0.0.0:$PORT -w 3