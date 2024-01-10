class City{
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;

  City({required this.isSelected, required this.city, required this.country, required this.isDefault});
  //List of Cities
  static List<City> citiesList = [
    City(
        isSelected: false,
        city: 'Mumbai',
        country: 'India',
        isDefault: true),
    City(
        isSelected: false,
        city: 'London',
        country: 'United Kindgom',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Tokyo',
        country: 'Japan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Delhi',
        country: 'India',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Beijing',
        country: 'China',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Paris',
        country: 'France',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Rome',
        country: 'Italy',
        isDefault: false),
    City(
        isSelected: false,
        city: 'New York',
        country: 'United States',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Dubai',
        country: 'United Arab Emirates',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Moscow',
        country: 'Russia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Hong Kong',
        country: 'China',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Berlin',
        country: 'Germany',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bangkok',
        country: 'Thailand',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Kathmandu',
        country: 'Nepal',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Nairobi',
        country: 'Kenya',
        isDefault: false),
  ];
  //Get the selected cities
  static List<City> getSelectedCities(){
    List<City> selectedCities = City.citiesList;
    return selectedCities
        .where((city) => city.isSelected == true)
        .toList();
  }
}