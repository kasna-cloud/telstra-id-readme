from flask import jsonify


def template(data, code=500):
    return {'message': {'errors': {'body': data}}, 'status_code': code}


CUSTOMER_NOT_FOUND = template(['Customer not found'], code=404)
ACCOUNT_NOT_FOUND = template(['Account not found'], code=404)
TRANSACTION_NOT_FOUND = template(['Transaction not found'], code=404)
UNKNOWN_ERROR = template([], code=500)


class InvalidUsage(Exception):
    status_code = 500

    def __init__(self, message, status_code=None, payload=None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_json(self):
        rv = self.message
        return jsonify(rv)

    @classmethod
    def customer_not_found(cls):
        return cls(**CUSTOMER_NOT_FOUND)

    @classmethod
    def account_not_found(cls):
        return cls(**ACCOUNT_NOT_FOUND)        

    @classmethod
    def transaction_not_found(cls):
        return cls(**TRANSACTION_NOT_FOUND)            

    @classmethod
    def unknown_error(cls):
        return cls(**UNKNOWN_ERROR)
