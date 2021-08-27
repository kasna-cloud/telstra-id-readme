# coding: utf-8

from flask import Blueprint
from flask_apispec import marshal_with
from sample.exceptions import InvalidUsage
from sample.customeraccounts.models import CustomerAccount
from .serializers import CustomerAccountSchema

blueprint = Blueprint('customeraccounts', __name__)

@blueprint.route('/api/customeraccounts/<id>', methods=('GET',))
@marshal_with(CustomerAccountSchema(many=True))
def get_customer_accounts(id):
    customer_accounts = CustomerAccount.query.filter_by(customer_id=id)
    return customer_accounts
