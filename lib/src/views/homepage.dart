import 'package:fleetly/src/blocs/getdriver_bloc.dart';
import 'package:fleetly/src/models/getdriver_model.dart';
import 'package:fleetly/src/models/getevents_model.dart';
import 'package:fleetly/src/models/userdetails_model.dart';
import 'package:fleetly/src/repositories/get_drivers_api_client.dart';
import 'package:fleetly/src/repositories/get_drivers_repository.dart';
import 'package:fleetly/src/user_profile.dart';
import 'package:fleetly/src/views/webView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
   
 final GetDriversListRepository getDriversListRepository = GetDriversListRepository(
    getDriversApiClient: GetDriversApiClient(
      httpClient: http.Client(),
    ),
  );
   Homepage({this.userData,this.getDriversListResultData,this.str,this.getEventsList, this.htmlText});
      UserDetails userData;
      GetEvents eventsList;
   String str;
   String htmlText;
  GetDrivers getDriversListResultData;
  GetEvents getEventsList;
  @override
  createState() => new _MyAppState();
}




 class _MyAppState extends State<Homepage> with TickerProviderStateMixin {
    int _cIndex = 0;
     List<UserDetails> userData;
  final List<MyTabs> _tabs = [new MyTabs(title: "Home"),
  new MyTabs(title: "Events"),
 // new MyTabs(title: "Profile")
  ];
     GetDriversListBloc _getDriversListBloc;
  GetDrivers getDriversListResultData;
  MyTabs _myHandler ;
  TabController _controller ;
     String str;
  GetEvents getEventsList;
String htmlText;
  void initState() {
    super.initState();

   //_validateAndGetData();
   
    //  _getDriversListBloc = GetDriversListBloc(getDriversListRepository: widget.getDriversListRepository);
    //  _getDriversListBloc.dispatch(GetDriversListCount());
    //_showList();
    _controller = new TabController(length: 2, vsync: this);
    _myHandler = _tabs[0];
      new MyTabs(title: "Events");

    _controller.addListener(_handleSelected);
  }
    void _handleSelected() {
    setState(() {
       _myHandler= _tabs[_controller.index];
    });
  }
  void _validateAndGetData() async { 
     final response = await getDriversData(widget.str);  
       print(response.body);
     if (response.statusCode == 200) {
       print(response);
       final resourcesList = getDriversFromJson(response.body);
         getDriversListResultData = resourcesList;
         print(getDriversListResultData);
      //    var newDateTimeObj2 = new DateFormat("dd/MM/yyyy HH:mm:ss").parse("10/02/2000 15:13:09");

      //    DateTime reporteddate = DateTime.parse(getDriversListResultData.lastReportedTime);
      // //var nowDate = new DateTime.now();
      // var formatter = new DateFormat('yyyy-MM-dd');

      // String formattedReportedDate = formatter.format(reporteddate);
      // print(formattedReportedDate); 
    // final http.Response response =
    // await http.post(Uri.encodeFull(url), body: activityData);
   
  
         final eventsResponse = await getEventsData(widget.str,getDriversListResultData.deviceIdentifier,'2019-08-12',getDriversListResultData.email);  
       print(eventsResponse.body);
       if (eventsResponse.statusCode == 200) {
       print(eventsResponse);
       final events = getEventsFromJson(eventsResponse.body);
       getEventsList = events;
       showList();
       }
       
     }
  }

 void _incrementTab(index) {
    setState(() {
      _cIndex = index;
        if (index == 0){
               print(widget.str);
              Padding(
                 padding: const EdgeInsets.only(top: 150),
                 child: FleetlyWebview(htmlText:widget.str),
               );
             }else{
                ListView.builder(
                   shrinkWrap: true,
                   itemCount: widget.getEventsList.events.length,
                   itemBuilder: (context, index) {
                     return _listItem(context,index);
                   },
                 );
             }
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    //_validateAndGetData();
   
      return Scaffold(
       backgroundColor: Colors.white,
       appBar: AppBar(
         automaticallyImplyLeading: false,
         // bottom: TabBar(
         //     indicatorColor: Colors.orange,
         //       tabs: [
         //         Tab(text: 'Home',),
         //         Tab(text: 'Events',),
         //        // Tab(text: 'Profile',),
         //       ],
         //     ), //backgroundColor: Color.fromRGBO(56, 66, 86, 1.0),
         backgroundColor: Colors.green,
         elevation: 0.0,
         
         title: Text(
           'Home',
           style: TextStyle(fontSize: 24),
         ),
       ),
       bottomNavigationBar: BottomNavigationBar(
         currentIndex: _cIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home,color: _cIndex== 0 ? Colors.green : Colors.black,),

            title: _cIndex== 0 ? new Text('Home',style: TextStyle(color: Colors.green),) :new Text('Home',style: TextStyle(color: Colors.black),),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.event,
            color: _cIndex== 1 ? Colors.green : Colors.black,),
            title: _cIndex== 1 ? new Text('Events',style: TextStyle(color: Colors.green),) :new Text('Events',style: TextStyle(color: Colors.black),),
            
          ),
         
         //  BottomNavigationBarItem(
         //    icon: Icon(Icons.person),
         //    title: Text('Profile')
         //  )
        ],
         onTap: (index){
            
              setState(() {
           

              });
               _incrementTab(index);
         },
      ),
    //    bottomNavigationBar: BottomAppBar(
    //   child: new Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: <Widget>[
    //       IconButton(
    //         icon: Icon(Icons.menu),
    //         onPressed: () {},
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.search),
    //         onPressed: () {},
    //       )
    //     ],
    //   ),
    // ),
       body: SafeArea(
         child: Container(child:  showData()),
         
        // child: Container(child:  showList()),
       ),
    );
    
  }
  Widget showData(){
    if (_cIndex == 0){
 return Container(child: FleetlyWebview(htmlText:widget.str),
 height: MediaQuery.of(context).size.height,);
    }else{
return ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.getEventsList.events.length,
                  itemBuilder: (context, index) {
                    return _listItem(context,index);
                  },
                );
    }
  }
  Widget showList(){
    print(widget.getEventsList);
    if (widget.getEventsList.events.length > 0) {

    
        var token = widget.str;
     
return TabBarView(
          children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: FleetlyWebview(htmlText:widget.str),
              ),
              
            Container(
    height: MediaQuery.of(context).size.height,

  //color: CommonColors.volunteerRetreatsListBackgrdColor,
  child:   ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.getEventsList.events.length,
                  itemBuilder: (context, index) {
                    return _listItem(context,index);
                  },
                ),
),
            // ProfilePage(userDetails:widget.userData)
            // Icon(Icons.directions_car),
            // Icon(Icons.directions_transit),
          ],);

}else{
  return TabBarView(
          children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: FleetlyWebview(htmlText:widget.str),
              ),
              
             Container(
               child: Center(child: Text('data'))
             ),
            // ProfilePage(userDetails:widget.userData)
            // Icon(Icons.directions_car),
            // Icon(Icons.directions_transit),
          ],);
}
               
  

  }
  Widget _listItem(BuildContext context, int index) {

  

  return Container(
    height: 120,
    child: Padding(
      padding: const EdgeInsets.only(top: 10,left: 8,right: 8),
      child: Card(
        color: Colors.white,
            child: Center(
              child: new ListTile(
          
          title: Container(
             // padding: EdgeInsets.only(left: 8),
              child: new Text(widget.getEventsList.events[index].type, style: new TextStyle(fontWeight: FontWeight.w400,fontSize: 18,),
              ),
          ),
          subtitle: Column(
            children: <Widget>[
             Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    
                        Flexible(child: new Text(widget.getEventsList.events[index].evetId, maxLines: 3,  overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w100,
                          //  color: CommonColors.blueShadeWhite,
                            letterSpacing: 0.2,
                            wordSpacing: 1)),
                        ),
                   // new Text(widget.getEventsList.events[index].locationAddress,maxLines: 2,overflow: TextOverflow.ellipsis, style: new TextStyle(fontWeight: FontWeight.w400,fontSize: 18,),
                  //  ),
                    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: <Widget>[
                    
                        Flexible(child: new Text(widget.getEventsList.events[index].locationAddress, maxLines: 3,  overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w100,
                          //  color: CommonColors.blueShadeWhite,
                            letterSpacing: 0.2,
                            wordSpacing: 1)),
                        ),
                   // new Text(widget.getEventsList.events[index].locationAddress,maxLines: 2,overflow: TextOverflow.ellipsis, style: new TextStyle(fontWeight: FontWeight.w400,fontSize: 18,),
                  //  ),
                    
                  ],
                ),
              ),

            ],
          ),
              onTap: () {
               

              },
          
        ),
            ),
      ),
    ),
  );
} 
   Widget showTabBarList() {


    var token = widget.str;
return TabBarView(
          children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: FleetlyWebview(htmlText:widget.str),
              ),
              
             Container(
               child: Center(child: Text('data'))
             ),
            // ProfilePage(userDetails:widget.userData)
            // Icon(Icons.directions_car),
            // Icon(Icons.directions_transit),
          ],);


               
   }
 }
class MyTabs {
  final String title;
  MyTabs({this.title});
}