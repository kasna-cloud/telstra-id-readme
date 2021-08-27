# coding: utf-8

from marshmallow import Schema, fields, pre_load, post_dump
class CustomerSchema(Schema):
    class Meta:
        fields = ('customer_id', 'age', 'app_reg_date', 'crn_status','date_of_birth', 'first_name','gender','ib_reg_date', 'long_lat', 'is_bankrupt', 'is_in_collection', 'is_deceased' )


class CustomersSchema(CustomerSchema):
    @post_dump(pass_many=True)
    def make_comment(self, data, many):
        return {'customers': data}        