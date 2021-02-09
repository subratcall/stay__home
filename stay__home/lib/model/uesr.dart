class User {
  final int id;
  final String name;
  final int topTime;
  final int accTime;
  final double latitude;
  final double longitude;

  User({
    this.id,
    this.name,
    this.topTime,
    this.accTime,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topTime': topTime,
      'accTime': accTime,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, topTime: $topTime, accTime: $accTime, latitude: $latitude, longitude: $longitude}';
  }
}
