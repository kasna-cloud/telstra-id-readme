# -*- coding: utf-8 -*-
"""User views."""
from flask import Blueprint, request
from flask_apispec import use_kwargs, marshal_with
from sqlalchemy.exc import IntegrityError
from sample.database import db
from sample.exceptions import InvalidUsage
from .models import Customer
from .serializers import CustomerSchema, CustomersSchema
from marshmallow import fields

blueprint = Blueprint('customer', __name__)

@blueprint.route('/api/customers/<id>', methods=('GET',))
@marshal_with(CustomerSchema)
def get_customer(id):
    customer = Customer.query.filter(Customer.customer_id == id).one()
    if not customer:
        raise InvalidUsage.customer_not_found()
    return customer

@use_kwargs({'limit': fields.Int(), 'offset': fields.Int()})
@blueprint.route('/api/customers', methods=('GET',))
@marshal_with(CustomersSchema(many=True))
def get_customers(limit=20, offset=0):
    res = Customer.query
    return res.offset(offset).limit(limit).all()
