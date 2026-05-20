import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Save as: lib/screens/rating/rating.dart
// ─────────────────────────────────────────────────────────────────────────────

class RatingReviewScreen extends StatefulWidget {
  const RatingReviewScreen({super.key});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  static const _orange = Color(0xFFE07B39);

  // ── Submit a review ────────────────────────────────────────────────────────
  Future<void> _submitReview(double rating, String comment) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final name = (user.displayName != null && user.displayName!.isNotEmpty)
        ? user.displayName!
        : user.email?.split('@').first ?? 'Anonymous';

    await FirebaseFirestore.instance.collection('app_reviews').add({
      'userId':    user.uid,
      'name':      name,
      'photoUrl':  user.photoURL ?? '',
      'rating':    rating,
      'comment':   comment.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Open write-review sheet ────────────────────────────────────────────────
  void _openReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WriteReviewSheet(onSubmit: _submitReview),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          // ── AppBar ─────────────────────────────────────────────────────────
          Container(
            color: _orange,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                    const Text(
                      'Ratings & Reviews',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ───────────────────────────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('app_reviews')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? [];

                // Compute avg from real data
                double avg = 0;
                if (docs.isNotEmpty) {
                  final sum = docs.fold<double>(0,
                          (s, d) => s + ((d['rating'] as num?)?.toDouble() ?? 0));
                  avg = sum / docs.length;
                }

                // Rating distribution
                final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
                for (final d in docs) {
                  final r = ((d['rating'] as num?)?.round()) ?? 0;
                  if (r >= 1 && r <= 5) dist[r] = (dist[r] ?? 0) + 1;
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    // Summary card
                    _SummaryCard(
                      avg: avg,
                      total: docs.length,
                      dist: dist,
                    ),

                    const SizedBox(height: 16),

                    // Section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer Reviews',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF222222),
                          ),
                        ),
                        Text(
                          '${docs.length} review${docs.length == 1 ? '' : 's'}',
                          style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFFAAAAAA)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (snapshot.connectionState ==
                        ConnectionState.waiting)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                              color: _orange),
                        ),
                      )
                    else if (docs.isEmpty)
                      _EmptyReviews()
                    else
                      ...docs.map((d) {
                        final data = d.data() as Map<String, dynamic>;
                        return _ReviewCard(data: data);
                      }),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      // ── FAB: Write Review ──────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: FirebaseAuth.instance.currentUser != null
            ? _openReviewSheet
            : () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please log in to write a review.')),
        ),
        backgroundColor: _orange,
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text(
          'Write a Review',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Card
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final double avg;
  final int total;
  final Map<int, int> dist;

  const _SummaryCard({
    required this.avg,
    required this.total,
    required this.dist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left — big score
          Column(
            children: [
              Text(
                total == 0 ? '—' : avg.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              _Stars(rating: avg, size: 17),
              const SizedBox(height: 5),
              Text(
                '$total review${total == 1 ? '' : 's'}',
                style: const TextStyle(
                    fontSize: 11.5, color: Color(0xFFAAAAAA)),
              ),
            ],
          ),

          const SizedBox(width: 20),
          const VerticalDivider(width: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(width: 20),

          // Right — bar chart
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = dist[star] ?? 0;
                final frac = total == 0 ? 0.0 : count / total;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded,
                          size: 12, color: Color(0xFFE07B39)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: frac,
                            minHeight: 7,
                            backgroundColor: const Color(0xFFF0F0F0),
                            color: const Color(0xFFE07B39),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFFAAAAAA)),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Review Card
// ─────────────────────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ReviewCard({required this.data});

  String _timeAgo(Timestamp? ts) {
    if (ts == null) return 'Just now';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context) {
    final name     = (data['name'] ?? 'Anonymous').toString();
    final rating   = (data['rating'] as num?)?.toDouble() ?? 0.0;
    final comment  = (data['comment'] ?? '').toString();
    final photoUrl = (data['photoUrl'] ?? '').toString();
    final ts       = data['createdAt'] as Timestamp?;

    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFFE0CC),
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : null,
                child: photoUrl.isEmpty
                    ? Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFFE07B39),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    _Stars(rating: rating, size: 13),
                  ],
                ),
              ),
              // Time + rating badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _timeAgo(ts),
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFFAAAAAA)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE07B39).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 11, color: Color(0xFFE07B39)),
                        const SizedBox(width: 3),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFE07B39),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              comment,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF444444),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Write Review Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _WriteReviewSheet extends StatefulWidget {
  final Future<void> Function(double rating, String comment) onSubmit;

  const _WriteReviewSheet({required this.onSubmit});

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  double _rating = 0;
  final _ctrl = TextEditingController();
  bool _submitting = false;

  static const _labels = ['Terrible', 'Bad', 'Okay', 'Good', 'Excellent'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating first.')),
      );
      return;
    }
    if (_ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first.')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(_rating, _ctrl.text);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _rating > 0 ? _labels[(_rating - 1).round().clamp(0, 4)] : '';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          left: 20,
          right: 20,
          top: 12,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              const Text(
                'Share Your Experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your feedback helps us improve',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
              ),
              const SizedBox(height: 20),

              // Stars
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final isSelected = i < _rating;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = i + 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          isSelected
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: isSelected
                              ? const Color(0xFFE07B39)
                              : Colors.grey.shade300,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 6),

              // Rating label
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  key: ValueKey(label),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE07B39),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Text field
              TextField(
                controller: _ctrl,
                maxLines: 4,
                maxLength: 300,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tell us about your experience...',
                  hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.all(14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFE07B39), width: 1.5),
                  ),
                ),
              ),

              // Extra padding to ensure submit button is clearly visible
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE07B39),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _submitting
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text(
                    'Submit Review',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              // Extra bottom padding for devices with gesture navigation
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Star widget
// ─────────────────────────────────────────────────────────────────────────────
class _Stars extends StatelessWidget {
  final double rating;
  final double size;

  const _Stars({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (i < rating.floor()) {
          icon = Icons.star_rounded;
        } else if (i < rating) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, color: const Color(0xFFE07B39), size: size);
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3ED),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.rate_review_outlined,
                  size: 40, color: Color(0xFFE07B39)),
            ),
            const SizedBox(height: 16),
            const Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Be the first to share your experience!',
              style: TextStyle(fontSize: 13.5, color: Color(0xFFAAAAAA)),
            ),
          ],
        ),
      ),
    );
  }
}