from marshmallow import Schema, fields, pre_load, post_dump


class CustomerAccountSchema(Schema):
    class Meta:
        fields = ('customer_id','account_id')