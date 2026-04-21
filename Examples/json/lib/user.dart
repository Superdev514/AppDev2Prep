class User {
  final int id;
  final String name;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        address: json['address'] as Address,
        phone: json['phone'] as String,
        website: json['website'] as String,
        company: json['company'] as Company
    );
  }

}

class Address{
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address(this.street, this.suite, this.city, this.zipcode, this.geo);
}

class Geo{
  final String lat;
  final String lng;

  Geo(this.lat, this.lng);


}

class Company{
  final String name;
  final String catchPhrase;
  final String bs;

  Company(this.name, this.catchPhrase, this.bs);
}

