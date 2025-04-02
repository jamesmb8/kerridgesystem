export 'pdf_generator_web.dart'
if (dart.library.html) 'pdf_generator_web.dart'
if (dart.library.io) 'pdf_generator_desktop.dart';

//use desktop if it's the app, or web if its on web
