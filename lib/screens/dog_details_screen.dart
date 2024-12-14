import 'package:flutter/material.dart';
import '../models/dog.dart';

class DogDetailsScreen extends StatefulWidget {
  final Dog dog;

  const DogDetailsScreen({super.key, required this.dog});

  @override
  State<DogDetailsScreen> createState() => _DogDetailsScreenState();
}

class _DogDetailsScreenState extends State<DogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'dog_${widget.dog.id}',
<<<<<<< HEAD
                child: _buildMainImage(),
=======
                child: Image.network(
                  'https://images.weserv.nl/?url=${Uri.encodeComponent(widget.dog.bestImageUrl)}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.pets,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
>>>>>>> 280d65d32295feb1bb24340978a9d8a1218ebcd9
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dog.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
<<<<<<< HEAD
                  _buildTextSection(
                    title: 'Temperament:',
                    content: widget.dog.temperament.isNotEmpty
                        ? widget.dog.temperament
                        : 'No information available',
                  ),
                  const SizedBox(height: 16),
                  if (widget.dog.images.isNotEmpty) _buildMoreImagesSection(),
=======
                  ...[
                  const Text(
                    'Temperament:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.dog.temperament,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                ],
                  if (widget.dog.images.isNotEmpty) ...[
                    const Text(
                      'More Images:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.dog.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.weserv.nl/?url=${Uri.encodeComponent(widget.dog.images[index].url)}',
                                width: 200,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[900],
                                    width: 200,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[900],
                                    width: 200,
                                    child: const Icon(
                                      Icons.pets,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
>>>>>>> 280d65d32295feb1bb24340978a9d8a1218ebcd9
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildMainImage() {
    return Image.network(
      'https://images.weserv.nl/?url=${Uri.encodeComponent(widget.dog.bestImageUrl)}',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[900],
          child: const Icon(
            Icons.pets,
            size: 50,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildTextSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildMoreImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More Images:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.dog.images.length,
            itemBuilder: (context, index) {
              final image = widget.dog.images[index];
              if (!image.isValid) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://images.weserv.nl/?url=${Uri.encodeComponent(image.url)}',
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[900],
                        width: 200,
                        child: const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
=======
>>>>>>> 280d65d32295feb1bb24340978a9d8a1218ebcd9
}
