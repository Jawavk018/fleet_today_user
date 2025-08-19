import 'package:localstorage/localstorage.dart';

class TokenService {
  String TOKEN_KEY = "token";
  String USER_KEY = "user";
  String CATEGORIES_KEY = "categories";
  String CITIES_KEY = "cities";
  String FEATUREDCOMPANIES_KEY = "featuredcompanies";

  final LocalStorage localStorage = new LocalStorage('driver');

  signOut() {
    localStorage.clear();
  }

  saveToken(token) {
    localStorage.deleteItem(TOKEN_KEY);
    localStorage.setItem(TOKEN_KEY, token);
  }

  getToken() {
    return localStorage.getItem(TOKEN_KEY);
  }

  saveUser(user) {
    // localStorage.deleteItem(USER_KEY);
    localStorage.setItem(USER_KEY, user);
  }

  getUser() {
    return localStorage.getItem(USER_KEY);
  }

  removeStorage() {
    localStorage.clear();
  }

  saveCategories(categories) {
    localStorage.deleteItem(CATEGORIES_KEY);
    localStorage.setItem(CATEGORIES_KEY, categories);
  }

  getCategories() {
    return localStorage.getItem(CATEGORIES_KEY);
  }

  saveCities(cities) {
    localStorage.deleteItem(CITIES_KEY);
    localStorage.setItem(CITIES_KEY, cities);
  }

  getCities() {
    return localStorage.getItem(CITIES_KEY);
  }

  saveFeaturedCompanies(featuredcompanies) {
    localStorage.deleteItem(FEATUREDCOMPANIES_KEY);
    localStorage.setItem(FEATUREDCOMPANIES_KEY, featuredcompanies);
  }

  getFeaturedCompanies() {
    return localStorage.getItem(FEATUREDCOMPANIES_KEY);
  }
}
