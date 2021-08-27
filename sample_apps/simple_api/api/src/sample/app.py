# -*- coding: utf-8 -*-
"""The app module, containing the app factory function."""
from flask import Flask
from sample.extensions import cache, db, migrate, cors

from sample import commands, accounts, customers, transactions, customeraccounts
from sample.settings import ProdConfig
from sample.exceptions import InvalidUsage

def create_app(config_object=ProdConfig):
    """An application factory, as explained here:
    http://flask.pocoo.org/docs/patterns/appfactories/.

    :param config_object: The configuration object to use.
    """
    app = Flask(__name__.split('.')[0])
    app.url_map.strict_slashes = False
    app.config.from_object(config_object)
    register_extensions(app)
    register_blueprints(app)
    register_errorhandlers(app)
    register_shellcontext(app)
    register_commands(app)   
    return app


def register_extensions(app):
    """Register Flask extensions."""
    cache.init_app(app)
    db.init_app(app)
    migrate.init_app(app, db)

def register_blueprints(app):
    """Register Flask blueprints."""
    origins = app.config.get('CORS_ORIGIN_WHITELIST', '*')
    cors.init_app(customers.views.blueprint, origins=origins)
    cors.init_app(accounts.views.blueprint, origins=origins)
    cors.init_app(transactions.views.blueprint, origins=origins)

    app.register_blueprint(customers.views.blueprint)
    app.register_blueprint(accounts.views.blueprint)
    app.register_blueprint(transactions.views.blueprint)
    app.register_blueprint(customeraccounts.views.blueprint)    


def register_errorhandlers(app):

    def errorhandler(error):
        response = error.to_json()
        response.status_code = error.status_code
        return response

    app.errorhandler(InvalidUsage)(errorhandler)


def register_shellcontext(app):
    """Register shell context objects."""
    def shell_context():
        """Shell context objects."""
        return {
            'db': db,
            'Customer': customers.models.Customer,
            'Transaction': transactions.models.Transaction,
            'Account': accounts.models.Account,
            'Account': customeraccounts.models.CustomerAccount,
        }

    app.shell_context_processor(shell_context)


def register_commands(app):
    """Register Click commands."""
    app.cli.add_command(commands.urls)
    app.cli.add_command(commands.seed)
