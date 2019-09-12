// THIS DOESN'T WORK AS EXPECTED, ISOLATES ARE THE WAY TO GO
import 'dart:async';
import 'dart:io';
import 'package:butterflies/butterflies.dart' as butterflies;

main(List<String> arguments) async {
  //print('Hello world: ${butterflies.calculate()}!');
  StreamController<int> intStream = StreamController<int>.broadcast();
  // intStream.stream.listen((data) async {
  //   await Future.delayed(Duration(milliseconds: 1000)).then((v){
  //     print("Processing ${data}");
  //   });  
  // });
  // The timer generates messages every half second, while a consumer using StreamIterator
  // processes each message for a second.
  int counter = 0;
  var timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
    String msg = 'SEND: ${counter++}';  
    stdout.writeln(msg);
    intStream.add(counter);
  });
  StreamIterator<int> si = StreamIterator<int>(intStream.stream);
  Future(() async { // Don't add await here otherwise we get an infinite loop.
    while(await si.moveNext()) {
        await Future.delayed(Duration(milliseconds: 1000)).then((v){
          print("Processing ${si.current}");
        });
      }
    }    
  );
  await Future.delayed(Duration(seconds: 5)).then((v){
    print("=== Cancelling Timer");
    timer.cancel();
  });
  exit(0);
}
