import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weatherfinal_proj/services/constants.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.optionsBuilder,
    this.onSetTextController,
    this.onTextChanged,
    this.onTextSubmitted,
    this.onSelected,
  });

  final FutureOr<Iterable<Map<String, dynamic>>> Function(TextEditingValue)
      optionsBuilder;
  final void Function(TextEditingController)? onSetTextController;
  final void Function(String)? onTextChanged;
  final void Function(String)? onTextSubmitted;
  final void Function(Map<String, dynamic>)? onSelected;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Map<String, dynamic>>(
      optionsViewOpenDirection: OptionsViewOpenDirection.down,
      optionsBuilder: widget.optionsBuilder,
      displayStringForOption: (op) => op["name"],
      optionsViewBuilder: (context, onSelected, options) {
        final optionsList = options.toList();
        return Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          child: Material(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final op = optionsList[index];

                if (op["country_code"] == "IL") {
                  op['country_code'] = 'PS';
                  op["country"] = "Palestine";
                } else if (op["admin1"]?.toLowerCase() == "west bank") {
                  op['country_code'] = 'PS';
                  op["country"] = "Palestine";
                } else if (op["name"]?.toLowerCase() == "gaza" &&
                    op["country"] == null) {
                  op['country_code'] = 'PS';
                  op["country"] = "Palestine";
                  op["admin1"] = "Gaza Strip";
                } else if (op["name"]?.toLowerCase() == "white house" &&
                    op["country_code"] == 'MA') {
                  op["name"] = "Casablanca";
                }

                final emoji = countryFlags[op["country_code"] ?? ""] ?? "🏴‍☠️";
                final country = op["country"] ?? "N/A";
                final city = op["name"] ?? "N/A";
                final state = op["admin1"] ?? "N/A";

                return ListTile(
                  leading: Icon(
                    Icons.location_city_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    city,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(230),
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "$country  $emoji",
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(230),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  dense: true,
                  onTap: () => onSelected(op),
                  // isThreeLine: true,
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: options.length,
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        this.controller = controller;
        widget.onSetTextController?.call(controller);
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          onChanged: widget.onTextChanged,
          onSubmitted: (value) {
            onFieldSubmitted();
            widget.onTextSubmitted?.call(value);
          },
          decoration: InputDecoration(
            hintText: "City Search...",
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(80),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        FocusScope.of(context).unfocus();
                        widget.onTextChanged?.call("");
                      });
                    },
                    icon: const Icon(Icons.clear_rounded),
                  )
                : null,
          ),
        );
      },
      onSelected: widget.onSelected,
    );
  }
}
