import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbaniser/app/controllers/kanban_controller.dart';
import 'package:kanbaniser/app/controllers/kanban_controller.event.dart';
import 'package:kanbaniser/core/utils/extensions.dart';

class NewSectionContainer extends StatelessWidget {
  const NewSectionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: () {
          context.read<KanbanController>().add(KanbanNewSectionEvent());
        },
        splashFactory: NoSplash.splashFactory,
        focusColor: context.theme.colorScheme.background,
        hoverColor: context.theme.colorScheme.background,
        highlightColor: context.theme.colorScheme.background,
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFBAAEAE),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add new section',
                style: context.text.bodyMedium.semibold.titleColor,
              ),
              const Spacer(),
              const Icon(
                Icons.add,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
