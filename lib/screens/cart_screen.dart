import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (context, cart, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Keranjang Belanja',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                '${cart.totalItems} buku dipilih',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.itemList.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                tooltip: 'Kosongkan Keranjang',
                onPressed: () => _showClearCartConfirm(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.itemList.isEmpty) {
            return _EmptyCart();
          }

          // Hitung threshold gratis ongkir (misal min. Rp 100.000)
          const freeShippingThreshold = 100000.0;
          final currentTotal = cart.totalPrice;
          final isFreeShipping = currentTotal >= freeShippingThreshold;
          final shippingProgress = (currentTotal / freeShippingThreshold).clamp(0.0, 1.0);

          return Column(
            children: [
              // Free Shipping & Promo Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: isFreeShipping
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                      : const Color(0xFFFF6F00).withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: isFreeShipping
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.2)
                          : const Color(0xFFFF6F00).withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isFreeShipping
                              ? Icons.local_shipping_rounded
                              : Icons.hourglass_top_rounded,
                          size: 18,
                          color: isFreeShipping
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFFF6F00),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isFreeShipping
                                ? '🎉 Selamat! Kamu mendapatkan GRATIS ONGKIR!'
                                : 'Tambah ${currency.format(freeShippingThreshold - currentTotal)} lagi untuk Gratis Ongkir!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isFreeShipping
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFFF6F00),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: shippingProgress,
                        backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFreeShipping
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFFF6F00),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              // Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: cart.itemList.length,
                  itemBuilder: (context, index) {
                    final item = cart.itemList[index];
                    return _CartItemCard(item: item, currency: currency);
                  },
                ),
              ),

              // Checkout Bottom Sheet
              _CheckoutFooter(cart: cart, currency: currency),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text('Kosongkan Keranjang',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text(
            'Apakah Anda yakin ingin menghapus semua buku dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Keranjang telah dikosongkan'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final NumberFormat currency;

  const _CartItemCard({required this.item, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtotal = item.book.price * item.quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Icon Avatar
                Container(
                  width: 58,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Book Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.book.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.book.author,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currency.format(item.book.price),
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete Single Item
                IconButton(
                  onPressed: () {
                    context
                        .read<CartProvider>()
                        .deleteItem(item.book.id);
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: Colors.red.shade400,
                  tooltip: 'Hapus Item',
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Subtotal & Quantity Stepper
            Row(
              children: [
                Text(
                  'Subtotal:',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  currency.format(subtotal),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Color(0xFFFF6F00),
                  ),
                ),
                const Spacer(),
                // Quantity Stepper
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepButton(
                        icon: Icons.remove_rounded,
                        color: Colors.red,
                        onTap: () {
                          context
                              .read<CartProvider>()
                              .removeItem(item.book.id);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      _StepButton(
                        icon: Icons.add_rounded,
                        color: const Color(0xFF2E7D32),
                        onTap: () {
                          context
                              .read<CartProvider>()
                              .addItem(item.book);
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
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  final CartProvider cart;
  final NumberFormat currency;

  const _CheckoutFooter({required this.cart, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total (${cart.totalItems} buku)',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                currency.format(cart.totalPrice),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF6F00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showCheckoutConfirm(context),
              icon: const Icon(Icons.payment_rounded, size: 18),
              label: const Text(
                'Checkout Sekarang',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutConfirm(BuildContext context) {
    final currency2 =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.shopping_bag_rounded, color: Color(0xFF2E7D32)),
            SizedBox(width: 10),
            Text('Konfirmasi Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lanjutkan pembayaran pesanan buku Anda?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Bayar:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    currency2.format(cart.totalPrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF6F00),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _processCheckout(context);
            },
            child: const Text('Bayar Sekarang'),
          ),
        ],
      ),
    );
  }

  void _processCheckout(BuildContext context) {
    final total = cart.totalPrice;
    final itemCount = cart.totalItems;
    final currency2 =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    context.read<CartProvider>().clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎉 Pembayaran Berhasil!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Text(
                    '$itemCount buku · ${currency2.format(total)}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove_shopping_cart_rounded,
              size: 72,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Keranjang Masih Kosong',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pilih buku favoritmu di katalog\ndan tambahkan ke keranjang.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Buka Katalog Buku'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
