import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/screens/tabs/chat_history_tab.dart';
import 'package:my_sivi_chat/src/screens/tabs/user_list_tab.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _selectedTab = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<AppState>(
      builder: (context, appState, _) {
        return SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  toolbarHeight: kToolbarHeight,
                  flexibleSpace: Column(
                    children: [
                      Center(child: _pillTabBar()),
                      SizedBox(height: 8),
                      Divider(
                        color: Colors.grey.withValues(alpha: 0.2),
                        thickness: 1,
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: IndexedStack(
              index: _selectedTab,
              children: [
                UsersListTab(key: const PageStorageKey('users_tab')),
                ChatHistoryTab(key: const PageStorageKey('chats_tab')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _pillTabBar() {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: _selectedTab == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: tabWidth - 4,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                children: [
                  _pillTabButton("Contacts", 0),
                  _pillTabButton("Chats", 1),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pillTabButton(String label, int index) {
    final selected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_selectedTab != index) {
            setState(() => _selectedTab = index);
          }
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: selected
                  ? Colors.black
                  : Theme.of(
                      context,
                    ).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
