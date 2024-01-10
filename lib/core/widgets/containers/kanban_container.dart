import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbaniser/app/controllers/kanban_controller.dart';
import 'package:kanbaniser/app/controllers/kanban_controller.event.dart';
import 'package:kanbaniser/app/models/section_model.dart';
import 'package:kanbaniser/core/utils/extensions.dart';
import 'package:kanbaniser/core/widgets/cards/kanban_card.dart';
import 'package:kanbaniser/core/widgets/utils/expansible_container.dart';

class KanbanContainer extends StatefulWidget {
  final int index;
  final SectionModel model;

  const KanbanContainer({
    required this.model,
    this.index = 0,
    super.key,
  });

  @override
  State<KanbanContainer> createState() => _KanbanContainerState();
}

class _KanbanContainerState extends State<KanbanContainer> {
  KanbanController? _controller;
  final _titleFocusNode = FocusNode();
  final _titleController = TextEditingController();

  bool _editable = false;

  @override
  void initState() {
    _titleFocusNode.addListener(_checkFocus);
    _titleController.text = widget.model.title;
    super.initState();
  }

  void _changeEditState() {
    setState(() {
      _editable = !_editable;
    });
    _titleFocusNode.requestFocus();
  }

  void _checkFocus() {
    if (!_titleFocusNode.hasFocus) {
      _controller?.add(KanbanEditSectionEvent(
        index: widget.index,
        newTitle: _titleController.text,
      ));
      setState(() {
        _editable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFBAAEAE),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 350,
          ),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Material(
                    color: const Color(0xFFBAAEAE),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ReorderableDragStartListener(
                            index: widget.index,
                            child: Container(
                              color: const Color(0xFFBAAEAE),
                              child: IgnorePointer(
                                ignoring: !_editable,
                                child: TextFormField(
                                  readOnly: !_editable,
                                  focusNode: _titleFocusNode,
                                  controller: _titleController,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: '',
                                    fillColor: Color(0xFFBAAEAE),
                                    filled: true,
                                  ),
                                  style: context.text.bodyMedium.semibold.titleColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          waitDuration: const Duration(milliseconds: 700),
                          message: 'Add a new task to this section',
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9)),
                          child: IconButton(
                            splashRadius: 18,
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<KanbanController>().add(
                                    KanbanNewTaskEvent(index: widget.index),
                                  );
                            },
                          ),
                        ),
                        Tooltip(
                          waitDuration: const Duration(milliseconds: 700),
                          message: 'Edit section',
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9)),
                          child: IconButton(
                            splashRadius: 18,
                            icon: Icon(
                              Icons.edit_note,
                              size: 16,
                              color: _editable
                                  ? context.theme.primaryColor
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _controller = context.read<KanbanController>();
                              _changeEditState();
                            },
                          ),
                        ),
                        Tooltip(
                          waitDuration: const Duration(milliseconds: 500),
                          message:
                              'Double tap to delete.\nAll tasks in this section will be deleted!',
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            onDoubleTap: () {
                              context.read<KanbanController>().add(
                                    KanbanDeleteSectionEvent(
                                        index: widget.index),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 120,
                    ),
                    child: ListView.builder(
                      key: UniqueKey(),
                      itemCount: widget.model.tasks.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (index == 0)
                              ExpansibleContainer(
                                sectionIndex: widget.index,
                                index: index,
                              ),
                            KanbanCard(
                              model: widget.model.tasks[index].copyWith(
                                index: index,
                                sectionIndex: widget.index,
                              ),
                              sectionIndex: widget.index,
                              index: index,
                            ),
                            ExpansibleContainer(
                              sectionIndex: widget.index,
                              index: index + 1,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (widget.model.tasks.isEmpty)
                    ExpansibleContainer(
                      expanded: true,
                      initalHeight: 80,
                      index: 0,
                      sectionIndex: widget.index,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
