from sample.database import (Model, db,
                              reference_col, relationship)


class Account(Model):
    __tablename__ = 'account'
    account_id = db.Column(db.String(100), primary_key=True)
    bsb = db.Column(db.String(100), nullable=False)		
    number = db.Column(db.String(100), nullable=False)
    opened_date = db.Column(db.DateTime, nullable=False)	
    prod_code = db.Column(db.String(100), nullable=False)	
    product_name = db.Column(db.String(100), nullable=False)	
    status = db.Column(db.String(100), nullable=False)	
    sub_prod_code = db.Column(db.String(100), nullable=False)	
    subproduct_name = db.Column(db.String(100), nullable=False)
    interest = db.Column(db.Float, nullable=False)
    org = db.Column(db.String(100), nullable=False)
    limit = db.Column(db.INTEGER, nullable=False)
    type = db.Column(db.String(20), nullable=False)
    
    def __init__(self, account_id, **kwargs):
        db.Model.__init__(self, account_id=account_id, **kwargs)

