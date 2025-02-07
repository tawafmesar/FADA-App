import '../../../../core/class/crud.dart';
import '../../../../linkapi.dart';
import 'dart:io';


class ScanHistoryData {
  Crud crud;
  ScanHistoryData(this.crud);

  postdata(String id) async {
    var response = await crud.postData(AppLink.scanhistoryview, {
      "id" : id
    });
    return response.fold((l) => l, (r) => r);
  }

  addFile(Map<String, dynamic> data, File file) async {
    var response = await crud.addRequestWithImageOne(AppLink.scanhistoryadd, data, file);
    return response.fold((l) => l, (r) => r);
  }


}