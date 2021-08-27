

import datetime as dt

from flask import Blueprint, jsonify
from flask_apispec import marshal_with, use_kwargs
from marshmallow import fields
from sample.exceptions import InvalidUsage
from .models import Transaction
from .serializers import TransactionSchema, TransactionsSchema
from marshmallow import fields

blueprint = Blueprint('transactions', __name__)

@use_kwargs({'limit': fields.Int(), 'offset': fields.Int()})
@blueprint.route('/api/transactions', methods=('GET',))
@marshal_with(TransactionsSchema(many=True))
def get_transactions(limit=20, offset=0):
    res = Transaction.query
    return res.offset(offset).limit(limit).all()


@blueprint.route('/api/transactions/<id>', methods=('GET',))
@marshal_with(TransactionSchema)
def get_transaction(id):
    transaction = Transaction.query.filter_by(txn_id=id).one()
    if not transaction:
        raise InvalidUsage.transaction_not_found()
    return transaction  