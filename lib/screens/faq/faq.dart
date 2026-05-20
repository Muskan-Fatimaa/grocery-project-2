import 'package:flutter/material.dart';

// ── FAQ Model ───────────────────────────────────────────────────────────────

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
  });
}

// ── FAQ Screen ──────────────────────────────────────────────────────────────

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int _expandedIndex = -1;

  final List<FaqItem> _faqs = const [
    FaqItem(
      question: "How fast is delivery?",
      answer:
      "We deliver within 30–60 minutes depending on your location and product availability.",
    ),
    FaqItem(
      question: "What are delivery charges?",
      answer:
      "Delivery is free on orders above Rs. 999. Below that, a small fee may apply.",
    ),
    FaqItem(
      question: "Can I return a product?",
      answer:
      "Yes, you can return damaged or incorrect items within 24 hours of delivery.",
    ),
    FaqItem(
      question: "How do I track my order?",
      answer:
      "Go to 'My Orders' section in the app to track your order in real time.",
    ),
    FaqItem(
      question: "What payment methods are accepted?",
      answer:
      "We accept Cash on Delivery, Easypaisa, JazzCash, and Debit/Credit cards.",
    ),
    FaqItem(
      question: "Can I cancel my order?",
      answer:
      "Yes, you can cancel your order before it is dispatched from the warehouse.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xffe07b39),
        title: const Text(
          "FAQs",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      // ── Body ──────────────────────────────────────────────────────────────
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 10),

          const Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xff222222),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Find answers to common questions about orders, delivery, and payments.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 16),

          // ── FAQ List ──────────────────────────────────────────────────────
          ...List.generate(_faqs.length, (index) {
            final faq = _faqs[index];
            final isExpanded = _expandedIndex == index;

            return _buildFaqTile(faq, index, isExpanded);
          }),
        ],
      ),
    );
  }

  // ── FAQ Tile ──────────────────────────────────────────────────────────────

  Widget _buildFaqTile(FaqItem faq, int index, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? -1 : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff222222),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xffe07b39),
                  ),
                ],
              ),
            ),
          ),

          // Answer section
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}