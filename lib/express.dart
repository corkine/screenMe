import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'api/dash.dart';

class ExpressIcon extends StatelessWidget {
  final int count;
  const ExpressIcon({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return count == 0
        ? const SizedBox()
        : Stack(alignment: Alignment.topRight, children: [
            Transform.translate(
                offset: const Offset(3, 3),
                child: Container(
                    padding: const EdgeInsets.only(left: 6, right: 6),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(count.toString(),
                        style: const TextStyle(color: Colors.black)))),
            IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.local_shipping, color: Colors.white))
          ]);
  }
}

class ExpressView extends ConsumerStatefulWidget {
  const ExpressView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpressViewState();
}

class _ExpressViewState extends ConsumerState<ExpressView> {
  @override
  Widget build(BuildContext context) {
    final d = ref
        .watch(getDashProvider.select((value) => value.value?.express ?? []));
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
            child: Column(
                children: d.map((e) {
          return ListTile(
              title: Text(e.name),
              subtitle: Text(e.info, style: const TextStyle(fontSize: 13)));
        }).toList(growable: false))));
  }
}
