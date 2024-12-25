import '../models/user.dart';

class UserRepository {
  final List<User> _users = [
    User(username: 'n', password: '1'),
    User(username: 'adminusername', password: 'admin123'),
  ];

  List<User> get users => _users;

  // Check if a user exists
  bool validateUser(String username, String password) {
    return _users.any((user) => user.username == username && user.password == password);
  }

  // Add a new user
  bool addUser(String username, String password) {
    if (_users.any((user) => user.username == username)) {
      return false;
      
       // username already exists
    }
    _users.add(User(username: username, password: password));
    return true;
  }
}
