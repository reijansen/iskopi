class CoffeeShop {
  const CoffeeShop({
    required this.id,
    required this.name,
    required this.image,
    required this.shortTags,
    required this.shortDescription,
    required this.location,
    required this.hours,
    required this.priceRange,
    required this.directions,
    required this.otherInfo,
  });

  final String id;
  final String name;
  final String image;
  final List<String> shortTags;
  final String shortDescription;
  final String location;
  final String hours;
  final String priceRange;
  final String directions;
  final String otherInfo;

  factory CoffeeShop.fromJson(Map<String, dynamic> json) {
    return CoffeeShop(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      shortTags: (json['shortTags'] as List<dynamic>).cast<String>(),
      shortDescription: json['shortDescription'] as String,
      location: json['location'] as String,
      hours: json['hours'] as String,
      priceRange: json['priceRange'] as String,
      directions: json['directions'] as String,
      otherInfo: json['otherInfo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'shortTags': shortTags,
      'shortDescription': shortDescription,
      'location': location,
      'hours': hours,
      'priceRange': priceRange,
      'directions': directions,
      'otherInfo': otherInfo,
    };
  }
}
