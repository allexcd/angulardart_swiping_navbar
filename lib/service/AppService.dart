library AppService;

import 'package:angular/angular.dart';
import 'package:angulardart_swiping_navbar/service/NavService.dart';

@Injectable()
class AppService {
  NavService navService;
  AppService(this.navService);

  void toggleSidemenu() {
    navService.toggleSidemenu();
  }
}