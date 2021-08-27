from marshmallow import Schema, fields, pre_load, post_dump


class AccountSchema(Schema):
    class Meta:
        fields = ('account_id', 'bsb', 'number', 'prod_code', 'product_name','status', 'sub_prod_code','subproduct_name')