import 'package:flutter/material.dart';

// Data models
class PillIdentificationResult {
  final ShapePrediction shape;
  final String imprint;
  final List<PillMatch> matches;

  PillIdentificationResult({
    required this.shape,
    required this.imprint,
    required this.matches,
  });

  factory PillIdentificationResult.fromJson(Map<String, dynamic> json) {
    var matchesData = json['matches'] as List<dynamic>? ?? [];
    return PillIdentificationResult(
      shape: ShapePrediction.fromJson(json['shape'] as Map<String, dynamic>? ?? {}),
      imprint: json['imprint'] as String? ?? 'N/A',
      matches: matchesData.map((e) => PillMatch.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class ShapePrediction {
  final String shapeClass;
  final double confidence;

  ShapePrediction({required this.shapeClass, required this.confidence});

  factory ShapePrediction.fromJson(Map<String, dynamic> json) {
    return ShapePrediction(
      shapeClass: json['class'] as String? ?? 'N/A',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PillMatch {
  final String name;
  final double score;

  PillMatch({required this.name, required this.score});

  factory PillMatch.fromJson(Map<String, dynamic> json) {
    final matchDetails = json['match'] as Map<String, dynamic>? ?? {};
    return PillMatch(
      name: json['pill_name'] as String? ?? 'No Name',
      score: (matchDetails['imprint_similarity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PillIdentificationResultsScreen extends StatelessWidget {
  final Map<String, dynamic> results;
  late final PillIdentificationResult _parsedResult;

  PillIdentificationResultsScreen({super.key, required this.results}) {
    _parsedResult = PillIdentificationResult.fromJson(results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pill Identification Results'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          Text(
            'Top Matches',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          _buildMatchesList(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Shape', '${_parsedResult.shape.shapeClass} (Confidence: ${(_parsedResult.shape.confidence * 100).toStringAsFixed(1)}%)'),
            const SizedBox(height: 8),
            _buildInfoRow('Imprint', _parsedResult.imprint),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchesList() {
    if (_parsedResult.matches.isEmpty) {
      return const Text('No matches found.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _parsedResult.matches.length,
      itemBuilder: (context, index) {
        final match = _parsedResult.matches[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(match.name),
            subtitle: Text('Score: ${match.score.toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }
}
