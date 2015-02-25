// Copyright (c) 2015, AlexCD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library header;

import 'package:angular/angular.dart';
import 'package:angulardart_swiping_navbar/service/NavService.dart';

@Component(
  selector: 'header',
  templateUrl: 'packages/angulardart_swiping_navbar/component/header.html',
  useShadowDom: false
)
class Header{
  NavService navService;

  Header(this.navService);

  void toggleNavbar(){
    navService.toggleNavbar();
  }
}