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


  void pushOperand(double value){
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
            double dividend = operand.removeLast();
            if(operand.first == 0.0){
               totalString = "Divide By Zero Error";
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

  void reset(){
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
                calculation = "${operand.first} $operator";
            }
            if(operand.length == 2){
                calculation = "${operand.last} $operator ${operand.first}";
            }
          }
          else{
              calculation = "${operand.first}";
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

            Text(
              totalString,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(calculation),

            ElevatedButton(onPressed: () => {setOperator("+")}, child: Text("+")),
            ElevatedButton(onPressed: () => {setOperator("-")}, child: Text("-")),
            ElevatedButton(onPressed: () => {setOperator("*")}, child: Text("x")),
            ElevatedButton(onPressed: () => {setOperator("/")}, child: Text("÷")),
            ElevatedButton(onPressed: () => {startDecimalOperation()}, child: Text(".")),
            ElevatedButton(onPressed: () => {calculateTotal()}, child: Text("=")),
            ElevatedButton(onPressed: () => {pushOperand(1.0)}, child: Text("1")),
            ElevatedButton(onPressed: () => {pushOperand(2.0)}, child: Text("2")),
            ElevatedButton(onPressed: () => {pushOperand(3.0)}, child: Text("3")),
            ElevatedButton(onPressed: () => {pushOperand(4.0)}, child: Text("4")),
            ElevatedButton(onPressed: () => {pushOperand(5.0)}, child: Text("5")),
            ElevatedButton(onPressed: () => {pushOperand(6.0)}, child: Text("6")),
            ElevatedButton(onPressed: () => {pushOperand(7.0)}, child: Text("7")),
            ElevatedButton(onPressed: () => {pushOperand(8.0)}, child: Text("8")),
            ElevatedButton(onPressed: () => {pushOperand(9.0)}, child: Text("9")),
            ElevatedButton(onPressed: () => {pushOperand(0.0)}, child: Text("0")),
          

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reset,
        tooltip: 'Reset',
        child: const Text("Reset"),
      ),
    );
  }
}
