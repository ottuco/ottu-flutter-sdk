import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  showToast(msg) {
    return Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: 5, fontSize: 10);
  }
}
