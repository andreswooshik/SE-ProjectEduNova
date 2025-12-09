# Performance Optimization Guide

This guide provides best practices and techniques for optimizing performance in the EduNova Flutter application.

## Table of Contents
- [Widget Performance](#widget-performance)
- [State Management](#state-management)
- [List Optimization](#list-optimization)
- [Image Optimization](#image-optimization)
- [Memory Management](#memory-management)
- [Build Time Optimization](#build-time-optimization)
- [Profiling and Debugging](#profiling-and-debugging)

## Widget Performance

### Use Const Constructors

Const widgets are not rebuilt when parent rebuilds.

```dart
// Good: Prevents unnecessary rebuilds
const Text('Static text')
const SizedBox(height: 16)
const Padding(padding: EdgeInsets.all(8))

// Avoid
Text('Static text')
SizedBox(height: 16)
```

**Impact**: Reduces rebuild count significantly, especially for static content.

### Extract Widgets

Create separate widget classes for complex or frequently used components.

```dart
// Good: Extracted widget
class UserAvatar extends StatelessWidget {
  final String imageUrl;
  const UserAvatar({Key? key, required this.imageUrl}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundImage: NetworkImage(imageUrl));
  }
}

// Use with const
const UserAvatar(imageUrl: 'url')

// Avoid: Inline complex widgets
build(context) {
  return Column(
    children: [
      CircleAvatar(...), // Rebuilt on every parent rebuild
    ],
  );
}
```

**Impact**: Allows Flutter to cache and reuse widgets efficiently.

### Use Keys Wisely

Keys help Flutter identify which widgets have changed.

```dart
// Good: Key for list items
ListView.builder(
  itemBuilder: (context, index) {
    final item = items[index];
    return ItemWidget(
      key: ValueKey(item.id), // Stable key
      item: item,
    );
  },
)

// Avoid: No keys for dynamic lists
ListView.builder(
  itemBuilder: (context, index) {
    return ItemWidget(item: items[index]); // May cause issues
  },
)
```

**Impact**: Prevents unnecessary animations and state loss in lists.

## State Management

### Use Provider Selectors

Watch only the data you need to avoid unnecessary rebuilds.

```dart
// Good: Select specific field
final userName = ref.watch(
  authProvider.select((state) => state.user?.fullName)
);

// Avoid: Watch entire state
final authState = ref.watch(authProvider);
final userName = authState.user?.fullName; // Rebuilds on any state change
```

**Impact**: Significantly reduces widget rebuilds.

### Dispose Resources

Always dispose controllers and subscriptions.

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _controller = TextEditingController();
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = someStream.listen((_) { });
  }
  
  @override
  void dispose() {
    _controller.dispose(); // Important!
    _subscription?.cancel(); // Important!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

**Impact**: Prevents memory leaks and crashes.

### Lazy Loading

Load data only when needed.

```dart
// Good: Load on demand
class CourseListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only loads when this widget is built
    final courses = ref.watch(coursesProvider);
    return ListView(...);
  }
}

// Avoid: Load everything upfront
void initState() {
  ref.read(coursesProvider.notifier).loadAllCourses();
  ref.read(modulesProvider.notifier).loadAllModules();
  ref.read(usersProvider.notifier).loadAllUsers();
}
```

**Impact**: Faster initial load time, better memory usage.

## List Optimization

### Use ListView.builder

For long lists, always use builder pattern.

```dart
// Good: Only builds visible items
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
)

// Avoid: Builds all items at once
ListView(
  children: List.generate(1000, (index) {
    return ListTile(title: Text('Item $index'));
  }),
)
```

**Impact**: Dramatically reduces memory usage and initial build time.

### Implement Pagination

Load data in chunks for very large datasets.

```dart
class InfiniteScrollList extends StatefulWidget {
  @override
  State<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  final ScrollController _scrollController = ScrollController();
  List<Item> _items = [];
  int _currentPage = 0;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMore();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }
  
  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    
    final newItems = await fetchItems(page: _currentPage);
    setState(() {
      _items.addAll(newItems);
      _currentPage++;
      _isLoading = false;
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return const CircularProgressIndicator();
        }
        return ItemWidget(item: _items[index]);
      },
    );
  }
}
```

**Impact**: Reduces memory usage, faster load times for large datasets.

### Use RepaintBoundary

Isolate expensive widgets to prevent unnecessary repaints.

```dart
// Good: Isolate complex widgets
RepaintBoundary(
  child: ComplexAnimatedWidget(),
)

// Use for list items with animations
ListView.builder(
  itemBuilder: (context, index) {
    return RepaintBoundary(
      child: AnimatedListItem(item: items[index]),
    );
  },
)
```

**Impact**: Reduces CPU usage during animations.

## Image Optimization

### Cache Network Images

```dart
// Good: Specify cache dimensions
Image.network(
  'https://example.com/image.jpg',
  cacheWidth: 200,
  cacheHeight: 200,
  fit: BoxFit.cover,
)

// Avoid: No cache control
Image.network('https://example.com/image.jpg')
```

**Impact**: Reduces memory usage, faster rendering.

### Use AssetImage for Static Assets

```dart
// Good: Preload important images
void initState() {
  super.initState();
  precacheImage(
    const AssetImage('assets/images/logo.png'),
    context,
  );
}
```

**Impact**: Prevents flashing on first load.

### Optimize Image Sizes

- Store multiple resolutions (1x, 2x, 3x)
- Compress images before adding to assets
- Use appropriate formats (PNG for graphics, JPEG for photos)
- Consider using WebP format for better compression

```
assets/images/
  logo.png        (1x - 100x100)
  2.0x/logo.png   (2x - 200x200)
  3.0x/logo.png   (3x - 300x300)
```

**Impact**: Faster loading, reduced app size.

## Memory Management

### Clear Collections

Clear large collections when no longer needed.

```dart
class DataManager {
  List<LargeObject> _cache = [];
  
  void clearCache() {
    _cache.clear();
    _cache = []; // Reset to release memory
  }
  
  void dispose() {
    clearCache();
  }
}
```

**Impact**: Prevents memory buildup.

### Use Weak References for Large Objects

For caching large objects, consider implementing a size-limited cache.

```dart
class SimpleCache<K, V> {
  final int maxSize;
  final Map<K, V> _cache = {};
  final List<K> _accessOrder = [];
  
  SimpleCache({this.maxSize = 100});
  
  V? get(K key) {
    if (_cache.containsKey(key)) {
      _accessOrder.remove(key);
      _accessOrder.add(key);
      return _cache[key];
    }
    return null;
  }
  
  void put(K key, V value) {
    if (_cache.length >= maxSize) {
      final oldestKey = _accessOrder.removeAt(0);
      _cache.remove(oldestKey);
    }
    _cache[key] = value;
    _accessOrder.add(key);
  }
  
  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }
}
```

**Impact**: Prevents unbounded memory growth.

### Avoid Memory Leaks

Common causes and solutions:

```dart
// Problem: Timer not cancelled
class BadWidget extends StatefulWidget {
  @override
  State<BadWidget> createState() => _BadWidgetState();
}

class _BadWidgetState extends State<BadWidget> {
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      // Update logic
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel(); // Don't forget!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Container();
}
```

**Impact**: Prevents crashes and memory leaks.

## Build Time Optimization

### Reduce Asset Size

- Compress images
- Remove unused fonts
- Use vector graphics (SVG) for icons when possible
- Enable minification for release builds

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
```

### Code Splitting

For very large apps, consider deferred loading:

```dart
// Define deferred import
import 'heavy_module.dart' deferred as heavy;

// Load when needed
void loadHeavyFeature() async {
  await heavy.loadLibrary();
  heavy.runHeavyFunction();
}
```

**Impact**: Reduces initial app size and load time.

## Profiling and Debugging

### Use Flutter DevTools

```bash
flutter run
# Press 'v' to open DevTools
```

Features:
- **Performance**: Timeline view, frame rendering times
- **Memory**: Heap snapshots, memory allocation tracking
- **CPU**: Profiler for identifying hot spots
- **Network**: Request/response inspection

### Performance Overlay

```dart
void main() {
  runApp(
    MaterialApp(
      showPerformanceOverlay: true, // Enable in debug mode
      home: MyApp(),
    ),
  );
}
```

Shows real-time FPS and frame rendering times.

### Identify Performance Issues

```dart
// Measure widget build time
import 'package:flutter/foundation.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    final widget = ExpensiveWidget();
    
    debugPrint('Build time: ${stopwatch.elapsedMilliseconds}ms');
    return widget;
  }
}
```

### Profile Release Builds

Always test performance on release builds:

```bash
flutter run --release
flutter build apk --release
```

Debug builds are slower due to debugging overhead.

## Performance Checklist

Before releasing a new version:

- [ ] All images optimized and cached
- [ ] Const constructors used for static widgets
- [ ] Long lists use ListView.builder
- [ ] Provider selectors used appropriately
- [ ] All controllers and subscriptions disposed
- [ ] No print() statements in production code
- [ ] Profiled with Flutter DevTools
- [ ] Tested on release build
- [ ] No memory leaks detected
- [ ] Frame rate > 60 FPS in normal usage
- [ ] App launch time < 3 seconds

## Common Performance Pitfalls

### Avoid in Build Method

```dart
// Bad: Creating objects in build
Widget build(BuildContext context) {
  final controller = TextEditingController(); // Created on every build!
  return TextField(controller: controller);
}

// Good: Create once
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
}
```

### Avoid Rebuilding Everything

```dart
// Bad: Entire tree rebuilds
setState(() {
  counter++;
});

// Good: Only rebuild what's needed
final counter = ref.watch(counterProvider);
// Only widgets watching counterProvider rebuild
```

## Resources

- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Effective Dart: Performance](https://dart.dev/guides/language/effective-dart/performance)

---

**Remember**: Premature optimization is the root of all evil. Always measure before optimizing!
