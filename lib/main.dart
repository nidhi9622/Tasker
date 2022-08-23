import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/dashboard.dart';
import 'package:task_manager/splashScreen.dart';
import 'localString.dart';

Future main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? status = true;
  status=preferences.getBool('theme') ;
  preferences.setInt('id', 0);
  runApp(GetMaterialApp(
      themeMode: status==true?ThemeMode.dark:ThemeMode.light,
      translations: LocalString(),
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.black54,
        scaffoldBackgroundColor:const Color(0xffededed ),
        appBarTheme: const AppBarTheme(backgroundColor:Colors.white),
      ),
      darkTheme:ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        primaryColorDark: Colors.white,
        primaryColorLight: Colors.white70,
        scaffoldBackgroundColor:const Color(0xff363535),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      home: const SplashScreen())
  );
}
class PageViewPage extends StatefulWidget {
  @override
  _PageViewPageState createState() => _PageViewPageState();
}
class _PageViewPageState extends State<PageViewPage> {
  List<Widget> _pages = [];
  final PageController _controller = PageController(initialPage: 0);
  double? _currentPage = 0;

  @override
  void initState() {
    _pages = [
      Container(
        color: Colors.red,
        child: Center(
            child: Text(
              'Page 1',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            )),
      ),
      Container(
        color: Colors.green,
        child: Center(
            child: Text(
              'Page 2',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            )),
      ),
      Container(
        color: Colors.blue,
        child: Center(
            child: Text(
              'Page 3',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            )),
      )
    ];
    //add
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PageView')),
      body: SafeArea(
        child: PageView.builder(
          itemBuilder: (context, index) {
            return Transform(
              transform: Matrix4.identity()..rotateZ(_currentPage! - index),
              child: _pages[index],
            );
          },
          scrollDirection: Axis.horizontal,
          controller: _controller,
          itemCount: _pages.length,
        ),
      ),
    );
  }
}

class CustomRoute extends PageRouteBuilder{
  dynamic child;
  dynamic type;
  CustomRoute({required this.child,required this.type}) : super( transitionDuration:const Duration(milliseconds: 700),
      pageBuilder: (context, animation, anotherAnimation) {
        return  child;
      },
      transitionsBuilder:(BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,Widget child
          ){
        return type(animation,child);
      } );
}
Widget scaleTransition(Animation<double> animation,Widget child,){
  return ScaleTransition(scale: animation,child: child,alignment: Alignment.topRight,);
}
Widget scaleTransition2(Animation<double> animation,Widget child,){
  return ScaleTransition(scale: animation,child: child,alignment: Alignment.center,);
}

// Use of secondary animation
Widget slideTransition(Animation<double> animation,Widget child,Widget exitChild, Animation<double> secondaryAnimation){
  animation=CurvedAnimation(
      curve: Curves.bounceIn,parent: animation
  );
  return Stack(
    children: [
      SlideTransition(
        position: Tween<Offset>(
            begin: const Offset (0,-1),
            end: Offset.zero
        ).animate(animation),
        child: child,
      ),
      SlideTransition(
        position: Tween<Offset>(
            begin: const Offset (0,-1),
            end: Offset.zero
        ).animate(secondaryAnimation),
        child: exitChild,
      ),
    ],
  );
}
Widget slideTransition2(Animation<double> animation,Widget child){

  animation=CurvedAnimation(
      curve: Curves.bounceIn,parent: animation
  );
  return SlideTransition(
    position: Tween<Offset>(
        begin: const Offset (0,1),
        end: Offset.zero
    ).animate(animation),
    child: child,
  );
}
Widget fadeTransition(Animation<double> animation,Widget child){
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

Widget rotationTransition(Animation<double> animation,Widget child){
  return RotationTransition(
    turns: animation,
    child: child,
    alignment: Alignment.center,
  );
}

Widget hero(){
  return Hero(tag: "img", child: Image.asset("assets/ocean.jpg"),placeholderBuilder: (context,size, widget) {
    return const SizedBox( width: 400.0, height: 400.0, child: CircularProgressIndicator(),); },
    flightShuttleBuilder: (flightContext, animation, direction,
        fromContext, toContext) {
      //return const Icon(Icons.animation, size: 150.0,);
      if(direction == HeroFlightDirection.push) {
        return const Icon(
          Icons.animation,
          size: 250.0,
        );
      } else {
        return const Icon(
          Icons.animation,
          size: 70.0,
        );
      }
    },
  );
}

Widget animationBuilder(Animation<double> animation){
  return AnimatedBuilder(animation: animation, builder: (context,widget){
    return Center(
      child: AnimatedContainer(duration:const Duration(seconds: 2),width: 200,height: 100,
        decoration:  BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [Colors.yellow,Colors.black],stops: [0,animation.value])),
      ),
    );
  });
}

Widget sizeTransition(Animation<double> animation,Widget child){
  return SizeTransition(
    child: child,
    axis: Axis.horizontal,
    axisAlignment: -1,
    sizeFactor: animation,
  );
}