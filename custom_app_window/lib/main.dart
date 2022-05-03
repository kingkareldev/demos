import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'src/Book.dart';
import 'src/WindowButtons.dart';
import 'src/page/BookDetailsPage.dart';
import 'src/page/BookListScreen.dart';
import 'src/page/UnknownScreen.dart';

void main() {
  runApp(const BooksApp());

  doWhenWindowReady(() {
    const initialSize = Size(900, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "King Karel";
    appWindow.show();
  });
}

class BooksApp extends StatefulWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  final BookRouterDelegate _routerDelegate = BookRouterDelegate();
  final BookRouteInformationParser _routeInformationParser = BookRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books App',
      debugShowCheckedModeBanner: false,
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

// --- ROUTES

abstract class RoutePath {}

class HomeRoute extends RoutePath {}

class DetailsRoute extends RoutePath {
  final int id;

  DetailsRoute(this.id);
}

class UnknownRoute extends RoutePath {}

// ---

class BookRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Book? _selectedBook;
  bool show404 = false;

  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  TransitionDelegate transitionDelegate = NoAnimationTransitionDelegate();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Navigator(
            key: navigatorKey,
            transitionDelegate: transitionDelegate,
            pages: [
              MaterialPage(
                key: const ValueKey('BooksListPage'),
                child: BooksListScreen(
                  books: books,
                  onTapped: _handleBookTapped,
                ),
              ),
              if (show404)
                MaterialPage(key: const ValueKey('UnknownPage'), child: UnknownScreen())
              else if (_selectedBook != null)
                BookDetailsPage(book: _selectedBook!)
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }

              // Update the list of pages by setting _selectedBook to null
              _selectedBook = null;
              show404 = false;
              notifyListeners();

              return true;
            },
          ),
        ),
        SizedBox(
          height: 50,
          child: Scaffold(
            backgroundColor: Colors.amberAccent,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MoveWindow(
                  child: Container(
                    color: Colors.pinkAccent,
                    child: const SizedBox(
                      width: 150,
                      child: Center(child: Text("Some text")),
                    ),
                  ),
                ),
                Expanded(child: MoveWindow()),
                const WindowButtons()
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TODO: ??
  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    if (path is UnknownRoute) {
      _selectedBook = null;
      show404 = true;
      return;
    }

    if (path is DetailsRoute) {
      if (path.id < 0 || path.id > books.length - 1) {
        show404 = true;
        return;
      }

      _selectedBook = books[path.id];
    } else {
      _selectedBook = null;
    }

    show404 = false;
  }

  // TODO: ??
  @override
  RoutePath get currentConfiguration {
    if (show404) {
      return UnknownRoute();
    }

    return _selectedBook == null ? HomeRoute() : DetailsRoute(books.indexOf(_selectedBook!));
  }

  void _handleBookTapped(Book book) {
    _selectedBook = book;
    notifyListeners();
  }
}

class BookRouteInformationParser extends RouteInformationParser<RoutePath> {
  // TODO: ??
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '');
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return HomeRoute();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'book') return UnknownRoute();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return UnknownRoute();
      return DetailsRoute(id);
    }

    // Handle unknown routes
    return UnknownRoute();
  }

  // TODO: ??
  @override
  RouteInformation? restoreRouteInformation(RoutePath path) {
    if (path is UnknownRoute) {
      return const RouteInformation(location: '/404');
    }
    if (path is HomeRoute) {
      return const RouteInformation(location: '/');
    }
    if (path is DetailsRoute) {
      return RouteInformation(location: '/book/${path.id}');
    }
    return null;
  }
}

// --- --- ---

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord> locationToExitingPageRoute,
    required Map<RouteTransitionRecord?, List<RouteTransitionRecord>> pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];

    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);
    }
    for (final RouteTransitionRecord exitingPageRoute in locationToExitingPageRoute.values) {
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForRemove();
        final List<RouteTransitionRecord>? pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final RouteTransitionRecord pagelessRoute in pagelessRoutes) {
            pagelessRoute.markForRemove();
          }
        }
      }
      results.add(exitingPageRoute);
    }
    return results;
  }
}
