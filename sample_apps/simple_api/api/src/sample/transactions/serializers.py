# coding: utf-8

from marshmallow import Schema, fields, pre_load, post_dump


class TransactionSchema(Schema):
    class Meta:
        fields = ('txn_id', 'acc_number', 'payment_id', 'txn_accounting_entry', 'txn_amount','txn_available_balance', 'txn_bpay_biller_code','txn_card_present_flag','txn_country', 'txn_currency', 'txn_date', 'txn_description', 'txn_merchant_code', 'txn_merchant_id','txn_status' , 'txn_stmt_description', 'txn_time' )


class TransactionsSchema(TransactionSchema):
    @post_dump(pass_many=True)
    def make_comment(self, data, many):
        return {'transactions': data}