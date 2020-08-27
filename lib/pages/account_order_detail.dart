import 'package:flutter/material.dart';
import 'package:kfb/api_provider/orders_api_provider.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/helpers/ui.dart';
import 'package:kfb/models/response/order.dart';
import 'package:kfb/widgets/app_loader.dart';

class AccountOrderDetailPage extends StatefulWidget {
  final int orderId;

  AccountOrderDetailPage({Key key, this.orderId}) : super(key: key);

  @override
  _AccountOrderDetailPageState createState() =>
      _AccountOrderDetailPageState(this.orderId);
}

class _AccountOrderDetailPageState extends State<AccountOrderDetailPage> {
  _AccountOrderDetailPageState(this._orderId);

  int _orderId;
  Order _order;
  bool _isLoading;
  OrdersApiProvider _ordersApiProvider;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          margin: EdgeInsets.only(left: 0),
        ),
        title: Text(
          "${capitalize("Order")} #" + _orderId.toString(),
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: _isLoading
            ? showAppLoader()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${capitalize("Date Ordered")}: " +
                      dateFormatted(
                          date: _order.dateCreated,
                          formatType: formatForDateTime(FormatType.Date))),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(child: Text("${capitalize("Ships to")}:")),
                        Flexible(
                          child: Text(
                            [
                              [
                                _order.shipping.firstName,
                                _order.shipping.lastName
                              ].where((t) => t != null).toList().join(" "),
                              _order.shipping.address1,
                              _order.shipping.address2,
                              _order.shipping.city,
                              _order.shipping.state,
                              _order.shipping.postcode,
                              _order.shipping.country,
                            ]
                                .where((t) => (t != "" && t != null))
                                .toList()
                                .join("\n"),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: wBoxShadow(),
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (cxt, i) {
                      return Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 8, right: 6),
                          title: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color(0xfffcfcfc), width: 1),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    _order.lineItems[i].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  capitalize(formatStringCurrency(
                                      total: _order.lineItems[i].price)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      formatStringCurrency(
                                        total: _order.lineItems[i].total,
                                      ),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText2
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "x" +
                                          _order.lineItems[i].quantity
                                              .toString(),
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _order.lineItems.length,
                  )),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _fetchOrder() async {
    _order = await _ordersApiProvider.getOrderById(_orderId);
    if (_order != null) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
