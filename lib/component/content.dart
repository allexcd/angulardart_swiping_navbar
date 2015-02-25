// Copyright (c) 2015, AlexCD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library content;

import 'package:angular/angular.dart';
import 'package:angulardart_swiping_navbar/service/NavService.dart';

@Component(
    selector: 'content',
    templateUrl: 'packages/angulardart_swiping_navbar/component/content.html',
    useShadowDom: false
)
class Content {
  NavService navService;
  Content(this.navService);
}