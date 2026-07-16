import 'package:flutter/material.dart';
import '../domain/note.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/theme/orbit_spacing.dart';
import '../../../shared/widgets/orbit_info_tile.dart';
import '../../../shared/widgets/orbit_group_card.dart';
import '../../../shared/widgets/orbit_search_bar.dart';

class NotesPage extends StatefulWidget {
  final StorageService storageService;

  const NotesPage({
    super.key,
    required this.storageService,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];
  bool _isLoading = true;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _searchController = TextEditingController();
  
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await widget.storageService.loadNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      _showError('Failed to load notes');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
                onSubmitted: (_) => _submitNote(),
              ),
              const SizedBox(height: OrbitSpacing.md),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearControllers();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitNote,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _submitNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isNotEmpty) {
      final newNote = Note()..title = title..content = content..createdAt = DateTime.now();
      try {
        await widget.storageService.saveNotes([newNote]);
        _clearControllers();
        if (mounted) Navigator.pop(context);
        _loadNotes();
      } catch (e) {
        _showError('Failed to save note');
      }
    }
  }

  void _deleteNote(Note note) async {
    try {
      await widget.storageService.deleteNote(note.id);
      _loadNotes();

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Note deleted'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await widget.storageService.saveNotes([note]);
                _loadNotes();
              },
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to delete note');
    }
  }

  void _clearControllers() {
    _titleController.clear();
    _contentController.clear();
  }

  String _formatDate(DateTime date) {
    final months = const [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredNotes = _notes.where((note) {
      final query = _searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Column(
        children: [
          if (_notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: OrbitSpacing.lg,
                vertical: OrbitSpacing.md,
              ),
              child: OrbitSearchBar(
                controller: _searchController,
                hintText: 'Search notes...',
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          Expanded(
            child: _notes.isEmpty
                ? _buildEmptyState(theme, colorScheme)
                : filteredNotes.isEmpty
                    ? _buildNoResults(theme, colorScheme)
                    : ListView.builder(
                        padding: const EdgeInsets.all(OrbitSpacing.lg),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[filteredNotes.length - 1 - index];
                          return _buildNoteItem(note, colorScheme, theme);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteItem(Note note, ColorScheme colorScheme, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OrbitSpacing.md),
      child: OrbitGroupCard(
        children: [
          OrbitInfoTile(
            title: note.title,
            subtitleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.content.isNotEmpty)
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                const SizedBox(height: OrbitSpacing.xs),
                Text(
                  _formatDate(note.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: colorScheme.error.withOpacity(0.7),
              onPressed: () => _deleteNote(note),
              tooltip: 'Delete Note',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 64, color: colorScheme.primary.withOpacity(0.1)),
          const SizedBox(height: OrbitSpacing.lg),
          Text(
            'No notes yet',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          Text(
            'Tap + to create your first note.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 48, color: colorScheme.onSurface.withOpacity(0.2)),
          const SizedBox(height: OrbitSpacing.lg),
          Text(
            'No matching results',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: OrbitSpacing.xs),
          Text(
            'Try another keyword.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
