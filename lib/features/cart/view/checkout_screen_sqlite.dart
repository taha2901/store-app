import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/routing/routers.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/features/cart/logic/local_cart_cubit.dart';
import 'package:store_app/features/cart/logic/states.dart';

class CheckoutScreen extends StatefulWidget {
  final LocalCartLoaded cartState;
  const CheckoutScreen({super.key, required this.cartState});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedPayment = 0;
  int selectedAddress = 0;
  bool _isPlacingOrder = false;

  final List<Map<String, dynamic>> addresses = [
    {
      'label': 'Home',
      'address': '123 Main Street, Cairo, Egypt',
      'icon': Icons.home_rounded,
    },
    {
      'label': 'Work',
      'address': '456 Business Ave, Giza, Egypt',
      'icon': Icons.business_rounded,
    },
  ];

  final List<Map<String, dynamic>> payments = [
    {'label': 'Visa •••• 2143', 'icon': Icons.credit_card_rounded},
    {'label': 'Cash on Delivery', 'icon': Icons.money_rounded},
  ];

 Future<void> _placeOrder() async {
  setState(() => _isPlacingOrder = true);

  // Simulate processing delay
  await Future.delayed(const Duration(milliseconds: 800));

  if (!mounted) return;

  setState(() => _isPlacingOrder = false);

  // Show order success dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _OrderSuccessDialog(
      total: widget.cartState.subtotal,
      itemCount: widget.cartState.totalQuantity,
      onBackToHome: () async {
        // هيمسح الكارت هنا بعد ما المستخدم ضغط Back
        await context.read<LocalCartCubit>().clearCart();

        Navigator.of(context).pushNamedAndRemoveUntil(
          Routers.home,
          (route) => false,
        );
      },
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final state = widget.cartState;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppColors.title),
                    ),
                  ),
                  const Expanded(
                    child: Text('Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.title,
                            letterSpacing: -0.3)),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Order Items Preview ──────────────────
                    _SectionLabel(
                        title: 'Order Items (${state.totalQuantity})'),
                    const SizedBox(height: 12),
                    ...state.items.take(3).map((item) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.thumbnail,
                                  width: 52, height: 52,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 52, height: 52,
                                    color: AppColors.tagBg,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.title)),
                                    Text('Qty: ${item.quantity}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.bodyText)),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${item.itemTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.title),
                              ),
                            ],
                          ),
                        )),
                    if (state.items.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '+ ${state.items.length - 3} more items',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.bodyText),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ── Delivery Address ─────────────────────
                    const _SectionLabel(title: 'Delivery Address'),
                    const SizedBox(height: 12),
                    ...List.generate(addresses.length, (i) =>
                      _SelectableCard(
                        selected: selectedAddress == i,
                        onTap: () => setState(() => selectedAddress = i),
                        child: Row(
                          children: [
                            _SelectableIcon(
                              icon: addresses[i]['icon'] as IconData,
                              selected: selectedAddress == i,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(addresses[i]['label'] as String,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.title)),
                                  const SizedBox(height: 2),
                                  Text(addresses[i]['address'] as String,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.bodyText)),
                                ],
                              ),
                            ),
                            if (selectedAddress == i) _CheckMark(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Payment Method ───────────────────────
                    const _SectionLabel(title: 'Payment Method'),
                    const SizedBox(height: 12),
                    ...List.generate(payments.length, (i) =>
                      _SelectableCard(
                        selected: selectedPayment == i,
                        onTap: () => setState(() => selectedPayment = i),
                        child: Row(
                          children: [
                            _SelectableIcon(
                              icon: payments[i]['icon'] as IconData,
                              selected: selectedPayment == i,
                            ),
                            const SizedBox(width: 12),
                            Text(payments[i]['label'] as String,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.title)),
                            const Spacer(),
                            if (selectedPayment == i) _CheckMark(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Order Summary ────────────────────────
                    const _SectionLabel(title: 'Order Summary'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          _PriceLine(
                            label: 'Items (${state.totalQuantity})',
                            value: '\$${state.originalTotal.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 10),
                          const _PriceLine(
                              label: 'Shipping Fee', value: 'Free'),
                          if (state.totalSaving > 0) ...[
                            const SizedBox(height: 10),
                            _PriceLine(
                              label: 'Discount',
                              value: '-\$${state.totalSaving.toStringAsFixed(2)}',
                            ),
                          ],
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(
                                color: AppColors.divider, thickness: 1),
                          ),
                          _PriceLine(
                            label: 'Total',
                            value:
                                '\$${state.subtotal.toStringAsFixed(2)}',
                            isBold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Place Order Button ───────────────────
                    GestureDetector(
                      onTap: _isPlacingOrder ? null : _placeOrder,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 54,
                        decoration: BoxDecoration(
                          color: _isPlacingOrder
                              ? AppColors.primary.withOpacity(0.7)
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _isPlacingOrder
                              ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Place Order  •  \$${state.subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.title));
}

class _SelectableCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  const _SelectableCard(
      {required this.selected,
      required this.onTap,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _SelectableIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _SelectableIcon({required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.tagBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18,
          color: selected ? Colors.white : AppColors.bodyText),
    );
  }
}

class _CheckMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 20,
      decoration: const BoxDecoration(
          color: AppColors.primary, shape: BoxShape.circle),
      child: const Icon(Icons.check, size: 12, color: Colors.white),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _PriceLine(
      {required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isBold ? 15 : 14,
                fontWeight:
                    isBold ? FontWeight.w700 : FontWeight.w400,
                color:
                    isBold ? AppColors.title : AppColors.bodyText)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                fontSize: isBold ? 16 : 14,
                fontWeight:
                    isBold ? FontWeight.w800 : FontWeight.w500,
                color: AppColors.title)),
      ],
    );
  }
}

// ─── Order Success Dialog ────────────────────────────────────
class _OrderSuccessDialog extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onBackToHome;

  const _OrderSuccessDialog({
    required this.total,
    required this.itemCount,
    required this.onBackToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, v, child) =>
                  Transform.scale(scale: v, child: child),
              child: Container(
                width: 84, height: 84,
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.successGreen, size: 46),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Order Placed! 🎉',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.title)),
            const SizedBox(height: 8),
            Text(
              '$itemCount item${itemCount > 1 ? 's' : ''} • \$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed successfully.\nEstimated delivery: 30–45 min.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.bodyText,
                  height: 1.5),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onBackToHome,
              child: Container(
                height: 50, width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('Back to Home',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}