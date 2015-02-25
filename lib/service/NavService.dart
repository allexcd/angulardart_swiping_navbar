library NavService;

import 'package:angular/angular.dart';

abstract class NavConfig{
  Map nav = {
      'navOpened': false
  };
}

@Injectable()
class NavService extends NavConfig{
  Map get getNav => nav;

  void toggleNavbar(){
    getNav["navOpened"] = !getNav["navOpened"];
  }

  void closeNavbar(){
    getNav["navOpened"] = false;
  }
}