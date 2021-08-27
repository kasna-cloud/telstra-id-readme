# -*- coding: utf-8 -*-
"""Click commands."""
import os
from glob import glob
from subprocess import call

import click
from flask import current_app
from flask.cli import with_appcontext
from werkzeug.exceptions import MethodNotAllowed, NotFound
from sample.extensions import db
import json
from sample.utils import getType, parse_datetime

HERE = os.path.abspath(os.path.dirname(__file__))
PROJECT_ROOT = os.path.join(HERE, os.pardir)




@click.command()
@click.option('--url', default=None,
              help='Url to test (ex. /static/image.png)')
@click.option('--order', default='rule',
              help='Property on Rule to order by (default: rule)')
@with_appcontext
def urls(url, order):
    """Display all of the url matching routes for the project.

    Borrowed from Flask-Script, converted to use Click.
    """
    rows = []
    column_headers = ('Rule', 'Endpoint', 'Arguments')

    if url:
        try:
            rule, arguments = (
                current_app.url_map.bind('localhost')
                .match(url, return_rule=True))
            rows.append((rule.rule, rule.endpoint, arguments))
            column_length = 3
        except (NotFound, MethodNotAllowed) as e:
            rows.append(('<{}>'.format(e), None, None))
            column_length = 1
    else:
        rules = sorted(
            current_app.url_map.iter_rules(),
            key=lambda rule: getattr(rule, order))
        for rule in rules:
            rows.append((rule.rule, rule.endpoint, None))
        column_length = 2

    str_template = ''
    table_width = 0

    if column_length >= 1:
        max_rule_length = max(len(r[0]) for r in rows)
        max_rule_length = max_rule_length if max_rule_length > 4 else 4
        str_template += '{:' + str(max_rule_length) + '}'
        table_width += max_rule_length

    if column_length >= 2:
        max_endpoint_length = max(len(str(r[1])) for r in rows)
        max_endpoint_length = (
            max_endpoint_length if max_endpoint_length > 8 else 8)
        str_template += '  {:' + str(max_endpoint_length) + '}'
        table_width += 2 + max_endpoint_length

    if column_length >= 3:
        max_arguments_length = max(len(str(r[2])) for r in rows)
        max_arguments_length = (
            max_arguments_length if max_arguments_length > 9 else 9)
        str_template += '  {:' + str(max_arguments_length) + '}'
        table_width += 2 + max_arguments_length

    click.echo(str_template.format(*column_headers[:column_length]))
    click.echo('-' * table_width)

    for row in rows:
        click.echo(str_template.format(*row[:column_length]))

@click.command()
@click.argument('file', type=click.File())
@with_appcontext
def seed(file):
    """Load database fixtures from JSON."""
    is_postgres = current_app.config.get('SQLALCHEMY_DATABASE_URI', '').startswith('postgres')
    db = current_app.extensions['sqlalchemy'].db
    print(db)
    sequences = []
    if is_postgres:
        sequences = [row[0] for row in db.session.execute("""
            SELECT relname FROM pg_class WHERE relkind = 'S'
        """)]

    models = {cls.__qualname__:cls for cls in db.Model._decl_class_registry.values() if isinstance(cls, type) and issubclass(cls, db.Model)}
    print(models)
    click.echo('Loading fixtures.')
    for fixture in json.load(file):
        model = models[fixture['model']]
        for model_kwargs in fixture['items']:
            d = {}
            for k, v in model_kwargs.items():
                if isinstance(v, bool):
                    d[k] = v
                else:    
                    classtype = getType(v) 
                    if classtype.__qualname__ == 'str':
                        d[k] = str(v)
                    elif classtype.__qualname__ == 'int':    
                        d[k]  = int(v)
                    elif classtype.__qualname__ == 'float':
                        d[k]  = float(v)
                    elif classtype.__qualname__ == 'datetime':
                        d[k]  = parse_datetime(v)                 
            model.create(**d)

        count = len(fixture['items'])
        suffix = 's' if count > 1 else ''
        click.echo(f"Adding {count} {fixture['model']} record{suffix}.")

        if is_postgres:
            seq_name = f'{model.__tablename__}_id_seq'
            if seq_name in sequences:
                db.session.execute(
                    f'ALTER SEQUENCE {seq_name} RESTART WITH :count',
                    {'count': count + 1}
                )

    db.session.commit()
    click.echo('Done.')