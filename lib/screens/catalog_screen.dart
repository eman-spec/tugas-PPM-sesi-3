import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['Semua', 'Novel', 'Sastra', 'Self-Help'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Book> get _filteredBooks {
    return sampleBooks.where((book) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          book.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final totalItems = context.watch<CartProvider>().totalItems;
    final totalPrice = context.watch<CartProvider>().totalPrice;
    final filtered = _filteredBooks;
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NusaBookstore',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'Toko Buku Nusantara',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Toggle Dark/Light Mode
          Container(
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: Colors.white,
                size: 20,
              ),
              tooltip: isDark ? 'Mode Terang' : 'Mode Gelap',
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ),
          // Cart Icon with Badge
          Container(
            margin: const EdgeInsets.only(right: 14),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Keranjang Belanja',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                ),
                if (totalItems > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 20),
                      child: Text(
                        totalItems > 99 ? '99+' : '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Hero Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF1E2235), const Color(0xFF131622)]
                    : [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '✨ DISKON MAHASISWA & GRATIS ONGKIR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Jelajahi Dunia Lewat\nKarya Terbaik',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Search Input Field
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A2E44)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari judul buku atau nama penulis...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                      backgroundColor:
                          isDark ? const Color(0xFF1E2235) : Colors.grey.shade100,
                      selectedColor: const Color(0xFF2E7D32),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : (isDark
                                  ? Colors.white12
                                  : Colors.grey.shade300),
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Book List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  _selectedCategory == 'Semua'
                      ? 'Semua Buku'
                      : 'Kategori: $_selectedCategory',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Text(
                  '${filtered.length} buku tersedia',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Books List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Buku tidak ditemukan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 90),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final book = filtered[index];
                      return _BookCard(book: book);
                    },
                  ),
          ),
        ],
      ),

      // Floating Cart Action Pill
      floatingActionButton: totalItems > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              backgroundColor: const Color(0xFFFF6F00),
              foregroundColor: Colors.white,
              elevation: 6,
              icon: const Icon(Icons.shopping_cart_checkout_rounded),
              label: Text(
                '$totalItems item · ${currency.format(totalPrice)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            )
          : null,
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Novel':
        return const Color(0xFF1565C0);
      case 'Sastra':
        return const Color(0xFF6A1B9A);
      case 'Self-Help':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Novel':
        return Icons.auto_stories_rounded;
      case 'Sastra':
        return Icons.history_edu_rounded;
      case 'Self-Help':
        return Icons.psychology_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catColor = _categoryColor(book.category);
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final quantity = cart.getQuantity(book.id);
        final isInCart = cart.isInCart(book.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isInCart
                  ? const Color(0xFF2E7D32).withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stylized Book Cover with Spine Accent
                Container(
                  width: 82,
                  height: 114,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        catColor.withValues(alpha: 0.85),
                        catColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: catColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Book Spine Highlight
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.18),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _categoryIcon(book.category),
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                book.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Book Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag & Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: catColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              book.category,
                              style: TextStyle(
                                color: catColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFB300), size: 16),
                          const SizedBox(width: 2),
                          Text(
                            book.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        book.author,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        book.description,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            currency.format(book.price),
                            style: const TextStyle(
                              color: Color(0xFFFF6F00),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          // Add to Cart / Qty Counter
                          if (!isInCart)
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<CartProvider>().addItem(book);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle_rounded,
                                            color: Colors.white, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '"${book.title}" masuk keranjang',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: const Color(0xFF2E7D32),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart_rounded,
                                  size: 15),
                              label: const Text('Beli',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32)
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF2E7D32)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _QtyButton(
                                    icon: Icons.remove_rounded,
                                    color: Colors.red,
                                    onPressed: () {
                                      context
                                          .read<CartProvider>()
                                          .removeItem(book.id);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2E7D32),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  _QtyButton(
                                    icon: Icons.add_rounded,
                                    color: const Color(0xFF2E7D32),
                                    onPressed: () {
                                      context
                                          .read<CartProvider>()
                                          .addItem(book);
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
