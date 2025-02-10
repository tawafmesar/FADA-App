import '../../../../core/class/crud.dart';
import '../../../../linkapi.dart';

class AllergyDBData {
  Crud crud;
  AllergyDBData(this.crud);

  postdata(String id) async {
    var response = await crud.postData(AppLink.allergydbview, {
      "id" : id
    });
    return response.fold((l) => l, (r) => r);
  }

  adddata(String ingredient_name,String description,String created_by_user_id) async {
    var response = await crud.postData(AppLink.allergydbadd, {
      "ingredient_name" : ingredient_name ,
      "description" : description,
      "created_by_user_id" : created_by_user_id,
    });
    return response.fold((l) => l, (r) => r);
  }

  removedata(String id,String user_id) async {
    var response = await crud.postData(AppLink.allergydbremove, {
      "id" : id ,
      "user_id" : user_id
    });
    return response.fold((l) => l, (r) => r);
  }

  activedata(String id,String user_id) async {
    var response = await crud.postData(AppLink.allergydbactive, {
      "id" : id ,
      "user_id" : user_id
    });
    return response.fold((l) => l, (r) => r);
  }

  deactivedata(String id,String user_id) async {
    var response = await crud.postData(AppLink.allergydbdeactive, {
      "id" : id ,
      "user_id" : user_id
    });
    return response.fold((l) => l, (r) => r);
  }

}