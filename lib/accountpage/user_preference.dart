class UserPreferences {
  static const myUser = User(
    imagePath:
    'https://media-exp3.licdn.com/dms/image/C4D03AQFEjN4ENV1rQA/profile-displayphoto-shrink_800_800/0/1556734543272?e=1630540800&v=beta&t=1Tn38y1SzPIQPzehFkXmgTtMEu6Aay2D0DKVmC6WJ-8',
    name: 'Mattia Capparella',
    email: 'mattia2@prova.com',
    about:
    ''
  );
}

class User {
  final String imagePath;
  final String name;
  final String email;
  final String about;

  const User({
    this.imagePath,
    this.name,
    this.email,
    this.about,
  });
}