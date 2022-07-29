import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nytimes_api/models/article_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> _articles = [];
  List<Article> _searchArticles = [];
  var loading = false;

  String pulpSection = '';

  @override
  void initState() {
    super.initState();
    _fetchAllArticles();
    _fetchSectionArticles(pulpSection);
  }

  /*@override
  void dispose() {
    super.dispose();
  }*/

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _searchArticles.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _articles.forEach((f) {
      if (f.title!.contains(text) || f.summary!.contains(text)) {
        _searchArticles.add(f);
      }
    });

    setState(() {});
  }

  _fetchAllArticles() async {
    List<Article> articles = await APIService().fetchAllArticles();
    setState(() {
      _articles = articles;
    });
  }

  _fetchSectionArticles(String pSec) async {
    List<Article> articles = await APIService().fetchArticlesBySection(pSec);
    setState(() {
      _articles = articles;
    });
  }

  _buildArticlesList(MediaQueryData mediaQuery) {
    List<Card> tiles = [];
    _articles.forEach((article) {
      tiles.add(_buildArticleTile(article, mediaQuery));
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: tiles,
    );
  }

  _buildSearchArticlesList(MediaQueryData mediaQuery) {
    List<Card> tiles = [];
    _searchArticles.forEach((article) {
      tiles.add(_buildSearchArticleTile(article, mediaQuery));
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: tiles,
    );
  }

  _launchURL(String url) async {
    //final url1 = 'https://youtube.com';
    if (await canLaunch(url)) {
      //canLaunchUrlString(url)
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
        enableJavaScript: true,
      ); //launchUrlString(url)
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildArticleTile(Article article, MediaQueryData mediaQuery) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: GestureDetector(
        onTap: () => _launchURL(article.url.toString()),
        child: Column(
          children: <Widget>[
            Container(
              //height: responsiveImageHeight(mediaQuery),
              height: 200.0,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(article.imageUrl.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              //height: 55,
              width: 365,
              color: Colors.black,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      //height: 40,
                      //width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(article.byline.toString()),
                    ),
                  ),
                  //Spacer(),
                  //Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      //height: 40,
                      //width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(article.publishedDate.toString()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              //height: responsiveTitleHeight(mediaQuery),
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                /*border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),*/
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    blurRadius: 6.0,
                  ),
                ],
              ),

              child: Text(
                article.title.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildSearchArticleTile(Article searchArticle, MediaQueryData mediaQuery) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: GestureDetector(
        onTap: () => _launchURL(searchArticle.url.toString()),
        child: Column(
          children: <Widget>[
            Container(
              //height: responsiveImageHeight(mediaQuery),
              height: 200.0,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(searchArticle.imageUrl.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              //height: 55,
              width: 365,
              color: Colors.black,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      //height: 40,
                      //width: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(searchArticle.byline.toString()),
                    ),
                  ),
                  //Spacer(),
                  //Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      //height: 40,
                      //width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(searchArticle.publishedDate.toString()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              //height: responsiveTitleHeight(mediaQuery),
              height: 80.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                /*border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),*/
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    blurRadius: 6.0,
                  ),
                ],
              ),

              child: Text(
                searchArticle.title.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/1.png', fit: BoxFit.cover),
        backgroundColor: Colors.black,
        title:
            //color: Colors.white,
            SizedBox(
          //padding: const EdgeInsets.all(20),
          height: 55,
          width: 260,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23.0)),
            child: ListTile(
              //contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Icon(
                  Icons.search,
                ),
              ),
              title: TextField(
                textAlign: TextAlign.center,
                cursorColor: Colors.black,
                controller: controller,
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
              trailing: IconButton(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                onPressed: () {
                  controller.clear();
                  onSearch('');
                },
                icon: Icon(Icons.cancel_outlined),
              ),
            ),
          ),
        ),
        //centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              'The New York Times\nTop Articles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            decoration: BoxDecoration(
                //color: Colors.black,
                /*borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),*/
                border: Border.all(
              color: Colors.black,
              width: 2,
            )),
          ),
          Container(

              /// рубрики статей
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  ElevatedButton(
                    child: Text('All'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      //pulpSection = '';
                      _fetchAllArticles();
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    child: Text('World'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      pulpSection = 'world';
                      _fetchSectionArticles(pulpSection);
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    child: Text('Fashion'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      pulpSection = 'fashion';
                      _fetchSectionArticles(pulpSection);
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    child: Text('Technology'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onPressed: () {
                      pulpSection = 'technology';
                      _fetchSectionArticles(pulpSection);
                    },
                  ),
                ],
              )),
          SizedBox(
            height: 15.0,
          ),
          Expanded(
              child: _searchArticles.length != 0 || controller.text.isNotEmpty
                  ? _buildSearchArticlesList(mediaQuery)
                  : _buildArticlesList(mediaQuery))
        ],
      ),
    );
  }
}
