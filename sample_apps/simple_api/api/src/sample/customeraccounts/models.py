from sample.database import (Model, db,
                              reference_col, relationship)


class CustomerAccount(Model):
    __tablename__ = 'customeraccount'
    customer_id = db.Column(db.String(80),primary_key=True, nullable=False)
    account_id = db.Column(db.String(100),primary_key=True, nullable=False)

    def __init__(self, customer_id, **kwargs):
        db.Model.__init__(self, customer_id=customer_id, **kwargs)

