part of 'my_widgets.dart';



class CustomSearchDelegate extends SearchDelegate<Consumable> {
  List<Consumable> consumables;
  String userId;
  String appId = localdata.EDAMAM_APPID;
  String appKey = localdata.EDAMAM_APPKEY;

  CustomSearchDelegate({required this.consumables, required this.userId});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context,
              Consumable.empty); // Replace null with a valid Consumable object
        });
  }

  Timer? _debounce;
  StreamController<List<Consumable>> _results = StreamController();

  @override
  Widget buildResults(BuildContext context) {
    if (query.length > 2) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () {
        fetchFoods(query).then((results) {
          _results.add(results);
        });
      });
    }

    return StreamBuilder<List<Consumable>>(
      stream: _results.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return ListTile(
                title: Text('${result.name} - ${result.calories}'),
                onTap: () {
                  close(context, result); // Return the selected result
                },
              );
            },
          );
        } else {
          return const Text('No results found.');
        }
      },
    );
  }

  Future<List<Consumable>> fetchFoods(String query) async {
    var filteredConsumables = consumables
        .where((consumable) =>
            consumable.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$appId&app_key=$appKey'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var hints = data['hints'] as List;
      log(data.toString());
      var resultsFromApi =
          hints.map((item) => Consumable.fromJson(item, userId)).toList();
      (hints as List).forEach((item) {
        (item['measures'] as List).forEach((measure) {
          if (measure['label'] == 'Milliliter') {
            log('~~~~~');
            log(measure['weight'].toString());
          }
        });
      });
      return filteredConsumables..addAll(resultsFromApi);
    } else {
      throw Exception('Failed to load foods');
    }
  }

  @override
  void showResults(BuildContext context) {
    if (query.length > 2) {
      fetchFoods(query).then((results) {
        _results.add(results);
      });
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 2) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () {
        fetchFoods(query).then((results) {
          _results.add(results);
        });
      });
    }

    return StreamBuilder<List<Consumable>>(
      stream: _results.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return ListTile(
                title: Text('${result.name} - ${result.calories}'),
                onTap: () {
                  close(context, result);
                },
              );
            },
          );
        } else {
          return const Text('No results found.');
        }
      },
    );
  }
}
