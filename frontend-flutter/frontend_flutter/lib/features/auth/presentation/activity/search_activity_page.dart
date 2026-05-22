import 'package:flutter/material.dart';
import '../../../../core/token_storage.dart';
import '../../../../core/api_client.dart';
import '../../../activitate/data/activitate_repository.dart';
import '../../../activitate/models/activitate_fizica_dto.dart';
import 'add_activity_page.dart';


class SearchActivityPage extends StatefulWidget {
  final DateTime dataActivitate;

  const SearchActivityPage({
    required this.dataActivitate,
    super.key
  });


  @override
  State<SearchActivityPage> createState() => _SearchActivityPageState();
}

class _SearchActivityPageState extends State<SearchActivityPage> {
  late final ActivitateRepository _repo;
  late final TextEditingController _searchController;
  List<ActivitateFizicaDto> _allActivities = [];
  List<ActivitateFizicaDto> _filteredActivities = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    _repo = ActivitateRepository(apiClient: apiClient);
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final activities = await _repo.getAllActivities();
      setState(() {
        _allActivities = activities;
        _filteredActivities = activities;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _filterActivities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredActivities = _allActivities;
      } else {
        _filteredActivities = _allActivities
            .where((a) => (a.nume ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alege activitate')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Caută activitate...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: _filterActivities,
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (!_loading)
            Expanded(
              child: _filteredActivities.isEmpty
                  ? Center(
                child: Text(_searchController.text.isEmpty ? 'Nicio activitate disponibilă' : 'Niciun rezultat'),
              )
                  : ListView.builder(
                itemCount: _filteredActivities.length,
                itemBuilder: (_, i) {
                  final activity = _filteredActivities[i];
                  return ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(activity.nume ?? 'Activitate'),

                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AddActivityPage(
                            activity: activity,
                            dataActivitate: widget.dataActivitate
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}