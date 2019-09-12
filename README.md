# Experimenting with Isolates
The joe_isolates.dart example was originally from [codingwithjoe.com/dart-fundamentals-isolates](https://codingwithjoe.com/dart-fundamentals-isolates/) but I significantly modified. In this example an isolate is spawned and it keeps sending messages, which is received by a listener, where I gave a try to [stream iterator](https://api.flutter.dev/flutter/dart-async/StreamIterator-class.html) and it worked great. 

It is possible to have multiple files each with a main function, and VSC runs the main in the open and active dart file; excellent.

[StreamQueue](https://api.flutter.dev/flutter/package-async_async/StreamQueue-class.html) and a number of other cool features are only available in the Flutter library, not in Dart standard.

Surprisingly the producer-consumer example worked as expected, too.
I was fighting an hour with a bug; the stream controller was defined with generic type int, but it was passed to a function called run-timer without the type value, and then within the run-timer funcion, by mistake I tried to add a string message to the stream; no compile time error, since the parameter didn't have type restriction, I received no exception at run-time, the app simply blocked on the point where I added the string to the stream. 

This project was created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
