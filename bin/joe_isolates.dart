import 'dart:io';
import 'dart:async';
import 'dart:isolate';

Isolate isolate;

void start() async {
  ReceivePort receivePort= ReceivePort(); //port for this main isolate to receive messages.
  isolate = await Isolate.spawn(runTimer, receivePort.sendPort);
  // The idea here is to start an async function that is monitoring the messages from the isolate
  // for 5 seconds, then it kills the isolate. For each message it starts a 2-second delayed process
  // to simulate a fully parallell and async producer consumer scenario.
  // The timeout killed the infinitely looping future excellently.
  StreamIterator si = StreamIterator(receivePort);
  await Future(() async {
    while(await si.moveNext()) {
      await Future.delayed(Duration(seconds: 2)).then((v){
        stdout.writeln("${si.current} received from isolate");
      });
    }
  }).timeout(Duration(seconds: 5),onTimeout: (){
    stop();
  });
  // receivePort.listen((data) {
  //   stdout.write('RECEIVE: ' + data + ', ');
  // });
}

void runTimer(SendPort sendPort) {
  int counter = 0;
  Timer.periodic(Duration(seconds: 1), (Timer t) {
    counter++;
    String msg = 'notification ' + counter.toString();  
    stdout.writeln('SEND: ' + msg + ' - ');  
    sendPort.send(msg);
  });
}

void stop() {  
  if (isolate != null) {
      stdout.writeln('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;        
  }  
}

void main() async {
  stdout.writeln('spawning isolate...');
  await start();
  // stdout.writeln('press enter key to quit...');
  // await stdin.first;
  await Future.delayed(Duration(seconds: 5)).then((v){
    stop();
  });
  stdout.writeln('goodbye!');
  exit(0);
}