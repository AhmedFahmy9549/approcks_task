class MosqueModel {
  List<Datum> data;
  Meta meta;

  MosqueModel({this.data, this.meta});

  factory MosqueModel.fromJson(Map<String, dynamic> json) => MosqueModel(
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      meta: Meta.fromJson(json["meta"]));
}

class Datum {
  int id;
  String nameEn;
  String nameAr;
  String address;
  String imagesUrl;
  double distance;
  double latitude;
  double longitude;

  Datum(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.address,
      this.imagesUrl,
      this.distance,
      this.latitude,
      this.longitude});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        address: json["address"],
        imagesUrl: json["images_url"],
        distance: json["distance"].toDouble(),
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name_en": nameEn,
        "name_ar": nameAr,
        "address": address.toString(),
        "images_url": imagesUrl,
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "distance": distance.toString(),
      };
}

class Meta {
  int currentPage;
  int lastPage;

  Meta({
    this.currentPage,
    this.lastPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
      );
}
