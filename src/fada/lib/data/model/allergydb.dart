class allergydb_model {
  int? allergyId;
  String? ingredientName;
  String? allergyDescription;
  int? derivativeId;
  String? derivativeName;
  String? derivativeDescription;
  String? status;
  String? createdBy;

  allergydb_model(
      {this.allergyId,
        this.ingredientName,
        this.allergyDescription,
        this.derivativeId,
        this.derivativeName,
        this.derivativeDescription,
        this.status,
        this.createdBy});

  allergydb_model.fromJson(Map<String, dynamic> json) {
    allergyId = json['allergy_id'];
    ingredientName = json['ingredient_name'];
    allergyDescription = json['allergy_description'];
    derivativeId = json['derivative_id'];
    derivativeName = json['derivative_name'];
    derivativeDescription = json['derivative_description'];
    status = json['status'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allergy_id'] = this.allergyId;
    data['ingredient_name'] = this.ingredientName;
    data['allergy_description'] = this.allergyDescription;
    data['derivative_id'] = this.derivativeId;
    data['derivative_name'] = this.derivativeName;
    data['derivative_description'] = this.derivativeDescription;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    return data;
  }
}