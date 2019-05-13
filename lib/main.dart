import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyAppTab extends StatelessWidget{
  List<dynamic> posts;
  List<dynamic> my_posts;
  MyAppTab(this.posts, this.my_posts);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          appBar: AppBar(
            bottom:TabBar(
              tabs: [
                Tab(icon: Icon(Icons.all_inclusive)),
                Tab(icon: Icon(Icons.accessibility)),
              ],
            ),
            title: Text("API Lab"), centerTitle: true,
          ),
          body:TabBarView(
            children: [
              SecondScreen(posts),
              ThirdScreen(my_posts),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget{
  List<dynamic> posts;
  SecondScreen(this.posts);

  @override
  Widget build(BuildContext context){
    var count = posts.length;
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context, int index){
        return new Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 8,
                  child:Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: Text(posts[index]["title"], style:TextStyle(color: Colors.white)),
                  ),
                ),
                Card(
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: Text(posts[index]["content"], style:TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        );
      },
    ));
  }
}

class ThirdScreen extends StatelessWidget{
  List<dynamic> my_posts;
  ThirdScreen(this.my_posts);

  @override
  Widget build(BuildContext context){
     var count = my_posts.length;
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context, int index){
        return new Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 8,
                  child:Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: Text(my_posts[index]["title"], style:TextStyle(color: Colors.white)),
                  ),
                ),
                Card(
                  elevation: 8,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                    child: Text(my_posts[index]["content"], style:TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}

class MyHomePageState extends State<MyHomePage>{
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String> login() async{
    String username = usernameController.text;
    String password = passwordController.text;
    String queryString = "?username=$username&password=$password";
    var url = "https://sleepy-stream-87265.herokuapp.com/api/login$queryString";
    var response = await http.get(Uri.encodeFull(url));
    var token = jsonDecode(response.body)["token"];
    return token;
  }

  void stuff(context) async{
    var token = await login();
    var allPosts = await getPosts(token);
    var my_posts = await myPosts(token);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppTab(allPosts, my_posts)));
  }

  Future<List<dynamic>> getPosts(token) async{
    var url = "https://sleepy-stream-87265.herokuapp.com/api/v1/posts";
    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var posts_json = jsonDecode(response.body);
    return posts_json;
  }

  Future<List<dynamic>> myPosts(token) async{
    var url = "https://sleepy-stream-87265.herokuapp.com/api/v1/my_posts";
    var response = await http.get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    var posts_json = jsonDecode(response.body);
    return posts_json;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API LAB'), centerTitle: true,
      ),
      body: Container(
      padding: const EdgeInsets.all(20),
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                  hintText: 'Enter Username'
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: 'Enter Password'
                ),
              ),
              SizedBox(height: 20,),
              RaisedButton(
                onPressed: (){stuff(context);},
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}