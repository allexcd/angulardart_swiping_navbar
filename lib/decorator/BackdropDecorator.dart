library backdrop.decorator;

import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:logging/logging.dart' show Logger;

/**
 * Backdrop Decorator Module
 */
class BackdropDecoratorModule extends Module {
  BackdropDecoratorModule() {
    bind(BackdropDecorator);
  }
}

@Decorator(
    selector: '[backdrop]'
)
class BackdropDecorator {
  final _log = new Logger('backdrop.decorator');
  dom.Element _element;

  BackdropDecorator(this._element){
    _log.fine('backdrop decorator loaded');
    _element.style.height = '${dom.document.body.scrollHeight}px';
  }
}