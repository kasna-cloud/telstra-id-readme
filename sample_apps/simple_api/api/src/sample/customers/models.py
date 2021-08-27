# -*- coding: utf-8 -*-
"""User models."""
import datetime as dt

from sample.database import Column, Model, db

class Customer(Model):
    __tablename__ = 'customer'
    customer_id = Column(db.String(80), primary_key=True, unique=True, nullable=False)
    age = Column(db.INTEGER, nullable=False)
    app_reg_date = Column(db.DateTime, nullable=False)
    crn_status = Column(db.String(80), nullable=False)
    date_of_birth = Column(db.DateTime, nullable=False)
    first_name = Column(db.String(120), nullable=False)
    gender = Column(db.String(20), nullable=False)
    ib_reg_date = Column(db.DateTime, nullable=False)
    long_lat = Column(db.String(120), nullable=False)
    is_bankrupt = Column(db.Boolean, nullable=False)
    is_in_collection = Column(db.Boolean, nullable=False)
    is_deceased = Column(db.Boolean, nullable=False)

    def __init__(self, customer_id, **kwargs):
        """Create instance."""
        db.Model.__init__(self, customer_id=customer_id, **kwargs)

    def __repr__(self):
        """Represent instance as a unique string."""
        return '<Customer({CustomerId!r})>'.format(customer_id=self.customer_id)

