
class User {

  final int? id;
  final String name;
  final String email;

  User({this.id, required this.name, required this.email});

  //dart object  into map to insert into db
  Map<String, dynamic> toMap() {

    return {
      'id':     id,
      'name':   name,
      'email':  email,
    };

  }

  //map from db into dart object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id:     map['id'],
      name:   map['name'],
      email:  map['email'],
    );
  }

}