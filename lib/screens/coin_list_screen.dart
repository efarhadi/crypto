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
  bool isVisibleUpdating = false;
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              //Define textfild for searching in crypto list
              child: TextField(
                onChanged: (value) {
                  _searchInlist(value);
                },
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  hintText: 'نام رمز ارز خود را وارد کنید',
                  hintStyle: TextStyle(
                    fontFamily: 'moraba',
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 0.0, style: BorderStyle.none),
                  ),
                  filled: true,
                  fillColor: greyColor,
                ),
              ),
            ),
            Visibility(
              visible: isVisibleUpdating,
              child: Text(
                '... در حال آپدیت لیست رمز ارز ها',
                style: TextStyle(
                    color: greenColor, fontFamily: 'moraba', fontSize: 17),
              ),
            ),
            Expanded(
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
          ],
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

//Function for seraching in cryptolist
  Future<void> _searchInlist(String value) async {
    //If the user clears data from the TextField, get data from the server
    if (value.isEmpty) {
      setState(() {
        isVisibleUpdating = true;
      });
      List<Crypto> result = await _getData();
      setState(() {
        cryptolists = result;
        isVisibleUpdating = false;
      });
      return;
    }
    List<Crypto> cryptoresult = [];
    cryptoresult = cryptolists!.where((element) {
      return element.name.toLowerCase().contains(
            value.toLowerCase(),
          );
    }).toList();
    setState(() {
      cryptolists = cryptoresult;
    });
  }
}
