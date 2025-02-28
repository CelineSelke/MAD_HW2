import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(foregroundColor: Colors.deepPurple, backgroundColor: Colors.white,shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(color: Colors.deepPurple)),
              minimumSize: const Size(90, 60),)),
        textTheme: TextTheme(headlineLarge: TextStyle(color: Colors.white), bodyLarge: TextStyle(color: Colors.white), headlineMedium: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var total = 0.0;
  String totalString = "0";
  String operator = "";
  Queue operand = Queue();
  int powerCount = -1;
  bool decimal = false;
  String calculation = "";


  void pushOperand(num value){
    setState(() {
        if(operand.isEmpty == true){
            operand.addFirst(value);
        }
        else{
            if((operator == "+" || operator == "-" || operator == "/" || operator == "*")){
                if(operand.length == 1){                 
                    operand.addFirst(value);
                }
                else if(operand.length == 2){
                    if(decimal == true){
                        operand.addFirst(operand.removeFirst() + (value * pow(10, powerCount)));
                        powerCount--;
                    }
                    else{
                        operand.addFirst(value + (10 * operand.removeFirst())); 

                    }
                }
            }
            else{
              if(decimal == true){
                  operand.addFirst(operand.removeFirst() + (value * pow(10, powerCount)));
                  powerCount--;
              }
              else{
                  operand.addFirst(value + (10 * operand.removeFirst())); 

              }

            }
        }
        buildCalculation();

    });
  
  }

  void calculateTotal(){
      if (operator == "+"){
          setState(() {
            total = operand.removeFirst() + operand.removeFirst();
          });
      }
      if (operator == "-"){
          setState(() {
            total = operand.removeLast() - operand.removeLast();
          });
      }
      if (operator == "/"){
          setState(() {
            num dividend = operand.removeLast();
            if(operand.last == 0.0){
               totalString = "Divide By Zero Error";

               return;
            }
            else{
               total = dividend / operand.removeLast();
            }
          });
      }
      if (operator == "*"){
          setState(() {
            total = operand.removeFirst() * operand.removeFirst();
          });
      } 

      decimal = false;

      operand.addFirst(total);

      setTotalString();

  }

  void setTotalString(){
    setState(() {
      if(total % 1 == 0){
          totalString = total.toString().split('.')[0];
      }
      else{
        var decimalPlaces = total.toString().split('.')[1].length;
        if(decimalPlaces < 6){
          totalString = total.toStringAsPrecision(decimalPlaces+1);
        }
        else{
          totalString = total.toStringAsPrecision(7);
        }
      }

    });

  }

  void setOperator(String pushedOperator){
      setState(() {

        operator = pushedOperator;
        powerCount = -1;

        if(decimal == true){
          decimal = false;
        }

        buildCalculation();
      
      });
  }

  void startDecimalOperation(){
      setState(() {
        decimal = true;
        if(operand.isEmpty == false && (operator == "+" || operator == "-" || operator == "/" || operator == "*") && operand.length < 2){
            operand.addFirst(0.0);
        }
        else if(operand.isEmpty == true){
            operand.addFirst(0.0);
        }
      });
  }

  void clear(){
    setState(() {
      total = 0;
      totalString = "0";
      operator = "";
      powerCount = -1;
      decimal = false;
      calculation = "";
      while(operand.isEmpty == false){
        operand.removeFirst();
      }
    });
  }

  void buildCalculation(){
      setState(() {
        if(operand.isEmpty == true){
            calculation = "";
        }
        else{
          if(operator != ""){
            if(operand.length == 1){
                calculation = "${operand.first.toStringAsPrecision(3)} $operator";
            }
            if(operand.length == 2){
                calculation = "${operand.last.toStringAsPrecision(3)} $operator ${operand.first.toStringAsPrecision(3)}";
            }
          }
          else{
              calculation = "${operand.first.toStringAsPrecision(3)}";
          }
        }
      });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(
              left: 30, top: 10, bottom: 10, right: 30
            ),
            
            child: 
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(calculation, style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis,),
              Spacer(),
              Text(
              totalString,
              style: Theme.of(context).textTheme.headlineLarge,
              overflow: TextOverflow.ellipsis,
              ),
              
            ],),
            ),
            
            
            
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              ElevatedButton(onPressed: () => {pushOperand(1.0)}, child: Text("1",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {pushOperand(2.0)}, child: Text("2",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {pushOperand(3.0)}, child: Text("3",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {setOperator("+")}, child: Text("+",style: Theme.of(context).textTheme.headlineMedium,)),
            ],),
            
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [ 
              ElevatedButton(onPressed: () => {pushOperand(4.0)}, child: Text("4",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {pushOperand(5.0)}, child: Text("5",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {pushOperand(6.0)}, child: Text("6",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {setOperator("-")}, child: Text("-",style: Theme.of(context).textTheme.headlineMedium,)),
            ],),

            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            ElevatedButton(onPressed: () => {pushOperand(7.0)}, child: Text("7",style: Theme.of(context).textTheme.headlineMedium,)),
            ElevatedButton(onPressed: () => {pushOperand(8.0)}, child: Text("8",style: Theme.of(context).textTheme.headlineMedium,)),
            ElevatedButton(onPressed: () => {pushOperand(9.0)}, child: Text("9",style: Theme.of(context).textTheme.headlineMedium,)),
            ElevatedButton(onPressed: () => {setOperator("*")}, child: Text("x",style: Theme.of(context).textTheme.headlineMedium,)),
            ],),

            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              ElevatedButton(onPressed: () => {startDecimalOperation()}, child: Text(".",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {pushOperand(0.0)}, child: Text("0",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {calculateTotal()}, child: Text("=",style: Theme.of(context).textTheme.headlineMedium,)),
              ElevatedButton(onPressed: () => {setOperator("/")}, child: Text("÷",style: Theme.of(context).textTheme.headlineMedium,)),
            ],),


          

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clear,
        tooltip: 'Clear',
        child: const Text("Clear"),
      ),
    );
  }
}
