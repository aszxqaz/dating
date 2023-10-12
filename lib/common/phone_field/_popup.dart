part of 'phone_field.dart';

class _CountriesSelectPopup extends StatefulWidget {
  const _CountriesSelectPopup({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<_CountriesSelectPopup> createState() => _CountriesSelectPopupState();
}

class _CountriesSelectPopupState extends State<_CountriesSelectPopup> {
  final list = ValueNotifier(countriesList);
  final focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => focusNode.requestFocus(),
    );
    super.initState();
  }

  @override
  void dispose() {
    list.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth - 32,
            ),
            child: Material(
              child: Column(
                children: [
                  TextField(
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (query) {
                      list.value = countriesList
                          .where((info) =>
                              info.name
                                  .toLowerCase()
                                  .startsWith(query.toLowerCase()) ||
                              info.dialCode.contains(query))
                          .toList();
                      debugPrint(list.value.length.toString());
                    },
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: list,
                      builder: (_, list, __) {
                        return ListView(
                          children: list
                              .map(
                                (info) => Material(
                                  child: InkWell(
                                    onTap: () {
                                      widget.onChanged(info.dialCode);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        '${info.name} (${info.dialCode})',
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
