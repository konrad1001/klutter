# Klutter

Klutter is tiny reproduction of Flutter, intended to explore exactly *how* Flutter bridges the gap between dart and native code on multiple platforms. 

## So far
- IOS support
- `create` an empty project, with ios templating.
- `build` and `run` an ios app onto simulator.
- `devices`, list available ios simulators and physical devices. 
- v1 - A very simple dart "compiler" transpiles a main.dart file into json which is then bundled into the app, which a simple SwiftUI "engine" 
reads and displays. At this point we can set a background colour in dart and this is displayed in a native iOS app. 

## For the future
- More sophisticated compilation.
- Engine using lower level apis.
- Expand device support.