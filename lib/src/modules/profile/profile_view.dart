import 'package:flutter/material.dart';
import 'package:sesoft_uni_mobile/src/helpers/extensions/build_context.dart';
import 'package:sesoft_uni_mobile/src/models/user.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_profile_icon.dart';

class ProfileView extends StatefulWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  // ignore: constant_identifier_names
  static const ROUTE = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static const _infoContainerMaxHeight = 78.0;
  final _infoContainerHeightNotifier = ValueNotifier(_infoContainerMaxHeight);
  final scrollController = ScrollController();

  void _listenScrollChanges() {
    final offset = scrollController.offset - 100;
    if (offset < 0) {
      _infoContainerHeightNotifier.value = _infoContainerMaxHeight;
    } else if (offset / 1.5 < (_infoContainerMaxHeight)) {
      _infoContainerHeightNotifier.value = _infoContainerMaxHeight - (offset / 1.5);
    } else {
      _infoContainerHeightNotifier.value = 0;
    }
  }

  @override
  void initState() {
    scrollController.addListener(_listenScrollChanges);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_listenScrollChanges);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(tabs: [
                      Tab(text: 'Postagens'),
                      Tab(text: 'Postagens'),
                      Tab(text: 'Curtidas'),
                    ]),
                    Divider(height: 0),
                  ],
                ),
              ),
              forceElevated: true,
              expandedHeight: 325,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.fadeTitle],
                centerTitle: false,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gabriel Pagotto',
                                  style: context.textTheme.titleMedium,
                                ),
                                Text(
                                  '@gabrielnpagotto',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SesoftProfileIcon(user: widget.user, size: 25),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                          valueListenable: _infoContainerHeightNotifier,
                          builder: (context, value, child) {
                            return Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: value,
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Aqui teoricamente seria onde a pessoa irá colocar alguma informação que ela ache necessário, no caso seria sua bio.',
                                      maxLines: 3,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.theme.colorScheme.outline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '177',
                                          style: context.textTheme.bodySmall?.copyWith(
                                            color: context.theme.colorScheme.outline,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                          ),
                                        ),
                                        const SizedBox(width: 2.5),
                                        Text(
                                          'Seguindo',
                                          style: context.textTheme.labelSmall?.copyWith(
                                            color: context.theme.colorScheme.outline,
                                            fontSize: 9,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '33',
                                          style: context.textTheme.labelSmall?.copyWith(
                                            color: context.theme.colorScheme.outline,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                          ),
                                        ),
                                        const SizedBox(width: 2.5),
                                        Text(
                                          'Seguidores',
                                          style: context.textTheme.labelSmall?.copyWith(
                                            color: context.theme.colorScheme.outline,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                collapseMode: CollapseMode.parallax,
              ),
              // floating: false,
              // snap: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(title: Text('Item #$index')),
                // Builds 1000 ListTiles
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
