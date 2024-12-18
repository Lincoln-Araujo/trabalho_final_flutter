import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dog.dart';
import '../services/database_service.dart';
import 'dog_details_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';

class DogsListScreen extends StatefulWidget {
  const DogsListScreen({super.key});

  @override
  State<DogsListScreen> createState() => _DogsListScreenState();
}

class _DogsListScreenState extends State<DogsListScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Dog> dogs = [];
  List<Dog> filteredDogs = [];
  bool isLoading = false;
  String? errorMessage;
  int currentPage = 0;
  final int limit = 12;
  int totalPages = 0;
  final TextEditingController _searchController = TextEditingController();
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalData() async {
    if (kIsWeb) {
      await fetchDogs();
      return;
    }

    try {
      final localDogs = await _dbService.fetchDogsByPage(currentPage, limit);
      if (localDogs.isNotEmpty) {
        setState(() {
          dogs = localDogs;
          filteredDogs = localDogs;
          isLoading = false;
        });
      } else {
        await fetchDogs();
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load local data. $e";
        isLoading = false;
      });
    }
  }

  void _filterDogs(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDogs = dogs;
      } else {
        filteredDogs = dogs
            .where((dog) => dog.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> fetchDogs() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final uri = Uri.parse('https://api.thedogapi.com/v1/breeds');
      final response = await http.get(
        uri,
        headers: {
          'x-api-key': 'live_yc0NdOigxPjeFVXhXTPFptxFHrWOF9M3P66NXbCcWgZY4n0A8mPhBACDzga4xnEL',
          if (kIsWeb) 'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> allData = json.decode(response.body);
        totalPages = (allData.length / limit).ceil();

        final int startIndex = currentPage * limit;
        final int endIndex = (startIndex + limit < allData.length)
            ? startIndex + limit
            : allData.length;

        final pageData = allData.sublist(startIndex, endIndex);
        final List<Dog> newDogs =
            pageData.map((json) => Dog.fromJson(json)).toList();

        for (var dog in newDogs) {
          await fetchDogImages(dog);
        }

        for (var dog in newDogs) {
          await _dbService.insertDog(dog, currentPage);
        }

        setState(() {
          dogs = newDogs;
          filteredDogs = newDogs;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load dogs: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error in fetchDogs: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> fetchDogImages(Dog dog) async {
    try {
      final uri = Uri.parse(
          'https://api.thedogapi.com/v1/images/search?breed_id=${dog.id}&limit=5');
      final response = await http.get(
        uri,
        headers: {
          'x-api-key': 'YOUR_API_KEY_HERE',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && mounted) {
          setState(() {
            dog.images = data
                .map((json) => DogImage.fromJson(json))
                .where((image) => image.isValid)
                .toList();

            if (dog.images.isNotEmpty &&
                (dog.imageUrl.isEmpty || !Uri.parse(dog.imageUrl).isAbsolute)) {
              dog.imageUrl = dog.images.first.url;
            }
          });
        }
      }
    } catch (e) {
      _logger.e('Error fetching images for ${dog.name}: $e');
    }
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      setState(() {
        currentPage++;

      });
      _loadLocalData();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _loadLocalData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Dog Breeds',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDogs,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search breeds...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            child: errorMessage != null
                ? _buildErrorWidget()
                : isLoading
                    ? _buildLoadingWidget()
                    : _buildGridView(),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $errorMessage',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: fetchDogs,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredDogs.length,
      itemBuilder: (context, index) {
        final dog = filteredDogs[index];
        return _buildDogCard(dog);
      },
    );
  }

  Widget _buildDogCard(Dog dog) {
    return Card(
      elevation: 2,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DogDetailsScreen(dog: dog),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Hero(
                tag: 'dog_${dog.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    'https://images.weserv.nl/?url=${Uri.encodeComponent(dog.bestImageUrl)}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.error,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  dog.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: currentPage > 0 ? previousPage : null,
            child: const Text('Previous'),
          ),
          Text(
            'Page ${currentPage + 1} of $totalPages',
            style: const TextStyle(color: Colors.white),
          ),
          ElevatedButton(
            onPressed: currentPage < totalPages - 1 ? nextPage : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
