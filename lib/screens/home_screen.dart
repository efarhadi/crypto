// Import necessary libraries and files
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_for_learn_api/data/models/crypto.dart';
import 'package:test_for_learn_api/screens/coin_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Call the getdata function when this widget initializes
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logoo.png'),
            ),
            SpinKitWave(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  // Function to fetch data from the API
  Future<void> getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    var mapdata = response.data['data'];
    List<Crypto> cryptolist = mapdata
        .map<Crypto>((mapjsonobject) => Crypto.fromMapData(mapjsonobject))
        .toList();

    // Navigate to the CryptoList screen with the fetched data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CryptoList(
          cryptolists: cryptolist,
        ),
      ),
    );
  }
}
