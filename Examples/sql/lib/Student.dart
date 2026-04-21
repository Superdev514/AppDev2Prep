class Student {
  final int id;
  final String name;
  final int age;

  Student({required this.id, required this.name, required this.age});

  //Must add this: converts dart object into db object and vice versa
  Map<String, Object?> toMap(){
    return{
      'id': id,
      'name': name,
      'age': age
    };
  }

}