import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kfb/helpers/tools.dart';
import 'package:kfb/models/woo_models.dart';

GestureDetector wProductCardItem(
    Product product, int index, BuildContext context, onTap) {
  return GestureDetector(
    onTap: () => onTap(product),
    child: Container(
      height: 500,
      width: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: CachedNetworkImage(
              imageUrl:
                  (product.images.length > 0 ? product.images.first.src : ""),
              width: 150,
            ),
          ),
          Container(
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xffFA4A33),
                  ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 13,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Color(0xff829112),
              borderRadius: BorderRadius.circular(16),
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                formatStringCurrency(total: product.price),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          Container(
            child: (product.onSale && product.type != "variable"
                ? Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '',
                        style: Theme.of(context).textTheme.bodyText1,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Was: ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black54, fontSize: 16),
                          ),
                          TextSpan(
                            text: formatStringCurrency(
                                total: product.regularPrice),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                " | ${workoutSaleDiscount(salePrice: product.salePrice, priceBefore: product.regularPrice)}% off",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black87, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : null),
            width: double.infinity,
          ),
        ],
      ),
    ),
  );
}

GestureDetector wProductCardItem2(
    AsyncSnapshot snapshot, int index, BuildContext context, onTap) {
  return GestureDetector(
    onTap: () => onTap(snapshot.data[index]),
    child: Container(
      height: 500,
      width: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: CachedNetworkImage(
              imageUrl: (snapshot.data[index]["images"][0]["src"]),
              width: 150,
            ),
          ),
          Container(
            child: Text(
              snapshot.data[index]["name"],
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Color(0xffFA4A33),
                  ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 13,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Color(0xff829112),
              borderRadius: BorderRadius.circular(16),
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                formatStringCurrency(total: snapshot.data[index]["price"]),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          Container(
            child: (snapshot.data[index]["on_sale"] &&
                    snapshot.data[index]["type"] != "variable"
                ? Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '',
                        style: Theme.of(context).textTheme.bodyText1,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Was: ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black54, fontSize: 16),
                          ),
                          TextSpan(
                            text: formatStringCurrency(
                                total: snapshot.data[index]["regular_price"]),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                " | ${workoutSaleDiscount(salePrice: snapshot.data[index]["sale_price"], priceBefore: snapshot.data[index]["regular_price"])}% off",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black87, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                : null),
            width: double.infinity,
          ),
        ],
      ),
    ),
  );
}
