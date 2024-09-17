import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../app/navigator.dart' as navigator;
import '../../localization.dart';
import '../../repositories/classes_repository.dart';
import '../../shared/snackbars.dart';
import 'breadcrumbs.dart';
import 'class_editor.dart';
import 'earq_brasil_form.dart';

class ClassEditorScreen extends StatefulWidget {
  const ClassEditorScreen({super.key, this.classId, this.parentId});

  final int? classId;
  final int? parentId;

  @override
  State<ClassEditorScreen> createState() => _ClassEditorScreenState();
}

class _ClassEditorScreenState extends State<ClassEditorScreen> {
  late final ClassEditor editor;

  @override
  void initState() {
    super.initState();
    editor = ClassEditor(
      repository: context.read<ClassesRepository>(),
      parentId: widget.parentId,
    )..init(editingClassId: widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ChangeNotifierProvider<ClassEditor>.value(
      value: editor,
      child: Scaffold(
        body: ClassEditorShortcuts(
          onSave: onSavePressed,
          child: const ClassEditorBody(),
        ),
        persistentFooterButtons: [
          TextButton(
            onPressed: navigator.closeClassEditor,
            child: Text(l10n.cancelButtonText),
          ),
          FilledButton(
            onPressed: onSavePressed,
            child: Text(l10n.saveButtonText),
          ),
        ],
      ),
    );
  }

  void onSavePressed() {
    try {
      editor.save();
    } on Exception {
      showErrorSnackBar(
        context,
        AppLocalizations.of(context).unableToSaveClassSnackbarText,
      );
    } finally {
      navigator.closeClassEditor();
    }
  }
}

class ClassEditorShortcuts extends StatelessWidget {
  const ClassEditorShortcuts({
    super.key,
    required this.child,
    required this.onSave,
  });

  final Widget child;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        const SingleActivator(
          LogicalKeyboardKey.keyS,
          control: true,
          includeRepeats: false,
        ): VoidCallbackIntent(onSave),
      },
      child: child,
    );
  }
}

class ClassEditorBody extends StatelessWidget {
  const ClassEditorBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClassEditorBreadcrumbs(),
          EarqBrasilForm(),
        ],
      ),
    );
  }
}
