library NavService;

import 'package:angular/angular.dart';

abstract class NavConfig{
  Map nav = {
      'menuOpened': false
  };
}

@Injectable()
class NavService extends NavConfig{
  Map get getNav => nav;

  void toggleSidemenu(){
    getNav["menuOpened"] = !getNav["menuOpened"];
  }

  void closeSidemenu(){
    getNav["menuOpened"] = false;
  }
}