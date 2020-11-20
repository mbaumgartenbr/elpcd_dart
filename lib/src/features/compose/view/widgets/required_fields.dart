import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/shared.dart';
import '../../bloc/compose_bloc.dart';

// TODO: Maybe use [flutter_hooks] for the `StatefulWidgets`

class RequiredFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metadados Obrigatórios',
              style: TextStyle(
                color: context.theme.accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _CodeFormField(),
            const SizedBox(height: 12),
            const _NameFormField(),
          ],
        ),
      ),
    );
  }
}

class _CodeFormField extends StatefulWidget {
  const _CodeFormField({Key key}) : super(key: key);

  @override
  __CodeFormFieldState createState() => __CodeFormFieldState();
}

class __CodeFormFieldState extends State<_CodeFormField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComposeBloc, ComposeState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (_, state) => _textController.text = state.code,
      buildWhen: (p, c) => p.code != c.code,
      builder: (_, state) {
        return TextFormField(
          controller: _textController,
          decoration: const InputDecoration(labelText: 'Código da Classe'),
          onChanged: (value) {
            context.read<ComposeBloc>().add(CodeChanged(code: value.trim()));
          },
          validator: (_) {
            return context.read<ComposeBloc>().state.codeError;
          },
        );
      },
    );
  }
}

class _NameFormField extends StatefulWidget {
  const _NameFormField({Key key}) : super(key: key);

  @override
  __NameFormFieldState createState() => __NameFormFieldState();
}

class __NameFormFieldState extends State<_NameFormField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComposeBloc, ComposeState>(
      listenWhen: (p, c) => p.isEditing != c.isEditing,
      listener: (_, state) => _textController.text = state.name,
      buildWhen: (p, c) => p.name != c.name,
      builder: (context, state) {
        return TextFormField(
          minLines: 1,
          maxLines: null,
          controller: _textController,
          decoration: const InputDecoration(labelText: 'Nome da Classe'),
          onChanged: (value) {
            context.read<ComposeBloc>().add(NameChanged(name: value.trim()));
          },
          validator: (_) {
            return context.read<ComposeBloc>().state.nameError;
          },
        );
      },
    );
  }
}