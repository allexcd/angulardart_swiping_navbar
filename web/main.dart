// Copyright (c) 2015, AlexCD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:angular/angular.dart';
import 'package:angular/animate/module.dart';
import 'package:angular/application_factory.dart';
import 'package:angulardart_swiping_navbar/wrapper/resource_url_resolver_wrapper.dart';
import 'package:angulardart_swiping_navbar/component/header.dart';
import 'package:angulardart_swiping_navbar/component/content.dart';
import 'package:angulardart_swiping_navbar/component/sidemenu.dart';
import 'package:angulardart_swiping_navbar/service/AppService.dart';
import 'package:angulardart_swiping_navbar/service/NavService.dart';
import 'package:angulardart_swiping_navbar/decorator/BackdropDecorator.dart';
import 'package:angulardart_custom_swipe/angulardart_custom_swipe.dart';

class AppModule extends Module{
  AppModule(){
    install(new AnimationModule());
    install(new BackdropDecoratorModule());

    bind(Header);
    bind(Content);
    bind(Sidemenu);
    bind(NavService);
    bind(customSwipe);
    bind(ResourceResolverConfig, toValue: new ResourceResolverConfig.resolveRelativeUrls(false));
    bind(ResourceUrlResolver, toImplementation: ResourceUrlResolver2);
  }
}

void main(){
  applicationFactory().addModule(new AppModule()).rootContextType(AppService).run();
}