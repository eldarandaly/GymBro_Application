import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference UserData =
      FirebaseFirestore.instance.collection('users data');
  Map<String, dynamic> modelData = {
    'age': 0,
    'sex': 0,
    'ChestpainType': 0,
    'RestingBP': 0,
    'Cholesterol': 0,
    'FastingBS': 0,
    'RestingECG': 0,
    'MaxHR': 0,
    'ExerciseAngina': 0,
    'Oldpeak': 0,
    'ST_Slope': 0
  };
  List<Map<String, dynamic>> h_R = [
    {'time': 0, 'rate': 70},
    {'time': 1, 'rate': 80},
    {'rate': 85, 'time': 2},
    {'time': 3, 'rate': 95},
    {'rate': 94, 'time': 4},
  ];
  List<Map<String, dynamic>> e_g = [
    {'time': 0.5, 'rate': 1.2},
    {'time': 1.0, 'rate': 1.25},
    {'rate': 1.4, 'time': 2.0},
    {'time': 2.5, 'rate': 1.24},
    {'rate': 1.19, 'time': 3.0},
  ];
  List<Map<String, dynamic>> m_p = [
    {
      'ptd_result': false,
      'arrhy_result': 'Supra-ventricular',
      'rand_result': false
    }
  ];
  Future addUserModelData() async {
    Map<String, dynamic> data = <String, dynamic>{'model_data': modelData};
    return await UserData.doc(uid).set(data);
  }

  Future addUserHRlData() async {
    return await UserData.doc(uid).set(h_R.cast<Map<String, dynamic>>);
  }

  Future updateUserData(
      String email,
      String username,
      String password,
      String confirmpassword,
      String phonenumber,
      String gender,
      String dateofbirth,
      String cholestrollevel,
      String bloodpressaure,
      String bloodsugar,
      String gradine,
      String gradineName,
      bool isADoctor) async {
    Map<String, dynamic> ModelDAta = <String, dynamic>{'model_data': modelData};
    return await UserData.doc(uid).set({
      'email': email,
      'username': username,
      'password': password,
      'confirmed password': confirmpassword,
      'phonenumber': phonenumber,
      'gender': gender,
      'date of birth': dateofbirth,
      'cholesterol level': cholestrollevel,
      'blood pressure': bloodpressaure,
      'blood sugar': bloodsugar,
      'model_data': modelData,
      'Heart_Rate_Readings': h_R,
      'gradine_Number': gradine,
      'gradine_Name': gradineName,
      'isADoctor': isADoctor,
      'Ecg_Readings': e_g,
      'Models_Predict': m_p
    });
  }
}
