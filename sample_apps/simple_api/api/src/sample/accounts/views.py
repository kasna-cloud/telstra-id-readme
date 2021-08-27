# coding: utf-8

from flask import Blueprint
from flask_apispec import marshal_with, use_kwargs
from sample.exceptions import InvalidUsage
from sample.accounts.models import Account
from .serializers import AccountSchema
from marshmallow import fields

blueprint = Blueprint('accounts', __name__)

@blueprint.route('/api/accounts/<id>', methods=('GET',))
@marshal_with(AccountSchema)
def get_account(id):
    account = Account.query.filter_by(account_id=id).one()
    if not account:
        raise InvalidUsage.account_not_found()
    return account

@use_kwargs({'limit': fields.Int(), 'offset': fields.Int()})
@blueprint.route('/api/accounts', methods=('GET',))
@marshal_with(AccountSchema(many=True))
def get_accounts(limit=20, offset=0):
    res = Account.query
    return res.offset(offset).limit(limit).all()