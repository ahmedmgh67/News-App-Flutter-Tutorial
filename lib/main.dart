import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/io_client.dart';
import 'dart:io';

void main() => runApp(MaterialApp(home: SplashPage()));

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var isLoaded = false;
  var news ;

  @override
  initState(){
    super.initState();
    request();
  }


  Widget articleCard ({String head, String imageUrl, String URL}){
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Material(
        elevation: 50.0,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              child: Text(
                head,
                style: TextStyle(
                  fontSize: 20.0
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Image.network(imageUrl,),
              padding: EdgeInsets.all(5.0),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        centerTitle: true,
      ),
      body: !isLoaded ? Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: news["articles"].length,
          itemBuilder: (context, index){
            return articleCard(
              head: news["articles"][index]["title"],
              imageUrl: news["articles"][index]["urlToImage"],
              URL: news["articles"][index]["url"]
            );
          }
      ),
    );
  }

  void request () async {
    var c = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true)
    ..connectionTimeout = Duration(seconds: 20);
    var i = IOClient(c);

    var res  = await i.get("https://newsapi.org/v2/top-headlines?country=eg&apiKey=9f8f7acace7d4f03a72ac8c13a1712a1");
    var decoded = jsonDecode(res.body);
    setState(() {
      news = decoded;
      isLoaded = true;
    });
  }
}
