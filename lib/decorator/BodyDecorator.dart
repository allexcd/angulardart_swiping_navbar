library BodyDecorator;

import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:angulardart_swiping_navbar/service/NavService.dart';

@Decorator(
    selector: '[enhance-body]'
)
class BodyDecorator {
  NavService navService;

  BodyDecorator(dom.Element target, this.navService){
    target.onClick.listen((e){
      e.stopPropagation();
      closeNavbar();
    });
  }

  void closeNavbar(){
    navService.closeNavbar();
  }
}