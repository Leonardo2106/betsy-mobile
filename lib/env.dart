class Env {
  static const apiBase = String.fromEnvironment('BetsyApiBase',
      defaultValue: 'https://betsy-backend-u01n.onrender.com/'
  );
}