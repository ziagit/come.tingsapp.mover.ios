import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/shared/functions/email_validator.dart';
import 'package:shipbay/shared/services/colors.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameOnCardController = new TextEditingController();
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController cvcController = new TextEditingController();
  TextEditingController expYearController = new TextEditingController();
  TextEditingController expMonthController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController postalcodeController = new TextEditingController();
  String _stripeError;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            style: TextStyle(fontSize: 12.0),
            validator: (value) {
              if (value.isEmpty) {
                return 'Not valid email!';
              }
              if (!isValidEmail(emailController.text)) {
                return 'Not valid email!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Address'),
            style: TextStyle(fontSize: 12.0),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required!';
              }
              return null;
            },
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'State'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: postalcodeController,
                  decoration: InputDecoration(labelText: 'Postalcode'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          TextFormField(
            controller: nameOnCardController,
            decoration: InputDecoration(labelText: 'Name on card'),
            style: TextStyle(fontSize: 12.0),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(16)],
            decoration: InputDecoration(
              labelText: 'Card number',
              prefixIcon: Icon(Icons.credit_card),
            ),
            style: TextStyle(fontSize: 12.0),
            validator: (value) {
              if (value.isEmpty) {
                return 'Card number is invalid!';
              }
              return null;
            },
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: cvcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                  decoration: InputDecoration(labelText: 'CVC'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a 3 digits number';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: expMonthController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
                  decoration: InputDecoration(labelText: 'Exp month'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a valid 2 ditis month';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: expYearController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
                  decoration: InputDecoration(labelText: 'Exp year'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a valid 2 digits year';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          Text(
            (_stripeError == null) ? '' : _stripeError,
            style: TextStyle(fontSize: 10.0, color: Colors.red),
          ),
          SizedBox(height: 20.0),
          _isLoading
              ? SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child:
                      CircularProgressIndicator(backgroundColor: Tingsapp.grey),
                )
              : IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(
                        () {
                          _isLoading = true;
                        },
                      );
                      /*  final CreditCard shippingCard = CreditCard(
                        number: cardNumberController.text,
                        expMonth: int.parse(expMonthController.text),
                        expYear: int.parse(expYearController.text),
                        cvc: cvcController.text,
                      );

                      StripePayment.createTokenWithCard(shippingCard).then(
                        (token) {
                          setState(() {
                            _stripeError = null;
                            _isLoading = false;
                          });
                          final data = {
                            'token': token.tokenId,
                            'email': emailController.text,
                            'address': addressController.text,
                            'city': cityController.text,
                            'state': stateController.text,
                            'postalcode': postalcodeController.text,
                            'name': nameOnCardController.text
                          };
                          Navigator.pop(context, data);
                        },
                      ).catchError(
                        (error) => {
                          setState(
                            () {
                              _isLoading = false;
                              _stripeError = error.message;
                            },
                          ),
                        },
                      ); */
                    }
                  },
                ),
        ],
      ),
    );
  }
}
