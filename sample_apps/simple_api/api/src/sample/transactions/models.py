# coding: utf-8

import datetime as dt

from flask_jwt_extended import current_user
from slugify import slugify

from sample.database import (Model, db, Column,
                              reference_col, relationship)

class Transaction(Model):
    __tablename__ = 'transaction'
    txn_id = db.Column(db.String(100),primary_key=True)
    acc_number = db.Column(db.String(100),nullable=False)
    payment_id = db.Column(db.String(100),nullable=False)
    txn_accounting_entry = db.Column(db.String(100),nullable=False)
    txn_amount = db.Column(db.FLOAT,nullable=False)
    txn_available_balance = db.Column(db.FLOAT,nullable=False)
    txn_bpay_biller_code = db.Column(db.String(100),nullable=False)
    txn_card_present_flag = db.Column(db.INTEGER,nullable=False)
    txn_country = db.Column(db.String(100),nullable=False)
    txn_currency = db.Column(db.String(100),nullable=False)
    txn_date  = db.Column(db.String(100),nullable=False)
    txn_description = db.Column(db.String(100),nullable=False)
    txn_merchant_code = db.Column(db.INTEGER,nullable=False)
    txn_merchant_id = db.Column(db.String(100),nullable=False)
    txn_status = db.Column(db.String(100),nullable=False)
    txn_stmt_description = db.Column(db.String(100),nullable=False)
    txn_time = db.Column(db.DateTime, nullable=False)
    txn_lat_long = db.Column(db.String(100),nullable=False)

    def __init__(self, txn_id, **kwargs):
        db.Model.__init__(self, txn_id=txn_id, **kwargs)