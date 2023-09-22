// Import necessary libraries and files
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_for_learn_api/data/models/constans/constants.dart';
import 'package:test_for_learn_api/data/models/crypto.dart';

// Main widget class
class CryptoList extends StatefulWidget {
  CryptoList({Key? key, this.cryptolists}) : super(key: key);
  List<Crypto>? cryptolists;

  @override
  State<CryptoList> createState() => _CryptoListState();
}

// State widget for CryptoList
class _CryptoListState extends State<CryptoList> {
  // List to store cryptocurrencies
  List<Crypto>? cryptolists;

  @override
  void initState() {
    super.initState();
    // Initialize the list with the provided data
    cryptolists = widget.cryptolists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'کریپتو بان',
          style: TextStyle(fontFamily: 'moraba'),
        ),
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: blackColor,
          backgroundColor: greenColor,
          child: ListView.builder(
            itemCount: cryptolists!.length,
            itemBuilder: ((context, index) {
              return _getListTile(cryptolists![index]);
            }),
          ),
          onRefresh: () async {
            // Refresh data from the API
            List<Crypto> freshData = await _getData();
            setState(() {
              cryptolists = freshData;
            });
          },
        ),
      ),
    );
  }

  // Function to display a cryptocurrency as a ListTile
  Widget _getListTile(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 17.0),
                ),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                      color: _getPriceColor(crypto.changePercent24hr)),
                ),
              ],
            ),
            SizedBox(
              width: 30,
              child: Center(
                child: _getIconChangePercent(crypto.changePercent24hr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine the icon based on percentage change
  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }

  // Function to determine text color based on percentage change
  Color _getPriceColor(double percentChange) {
    return percentChange <= 1 ? redColor : greenColor;
  }

  // Function to fetch data from the API
  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    var mapdata = response.data['data'];
    List<Crypto> cryptoList = mapdata
        .map<Crypto>((mapJsonObject) => Crypto.fromMapData(mapJsonObject))
        .toList();
    return cryptoList;
  }
}
