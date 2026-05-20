import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Save as: lib/screens/delivery_address/my_saved_addresses_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class MySavedAddressesScreen extends StatelessWidget {
  const MySavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE8631A),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'My Delivery Addresses',
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
          Expanded(
            child: uid == null
                ? const Center(child: Text('Please log in.'))
                : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('addresses')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFFE8631A)));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return _EmptyAddresses();
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data =
                    docs[i].data() as Map<String, dynamic>;
                    return _AddressCard(
                        data: data, docId: docs[i].id, uid: uid);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final String uid;

  const _AddressCard({
    required this.data,
    required this.docId,
    required this.uid,
  });

  Future<void> _setDefault(BuildContext context) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses');

    final all = await ref.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final d in all.docs) {
      batch.update(d.reference, {'isDefault': d.id == docId});
    }
    await batch.commit();
  }

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Address'),
        content: const Text('Remove this address?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('users').doc(uid)
          .collection('addresses').doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDefault = data['isDefault'] == true;
    final name     = data['name'] ?? '';
    final phone    = data['phone'] ?? '';
    final house    = data['house'] ?? '';
    final area     = data['area'] ?? '';
    final city     = data['city'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDefault
            ? Border.all(color: const Color(0xFFE8631A), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8631A).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Color(0xFFE8631A), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      Text(phone,
                          style: const TextStyle(
                              fontSize: 12.5, color: Color(0xFFAAAAAA))),
                    ],
                  ),
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8631A).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Default',
                        style: TextStyle(
                          color: Color(0xFFE8631A),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '$house, $area, $city',
              style: const TextStyle(
                  fontSize: 13.5, color: Color(0xFF555555), height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!isDefault)
                  TextButton.icon(
                    onPressed: () => _setDefault(context),
                    icon: const Icon(Icons.check_circle_outline,
                        size: 15, color: Color(0xFF4CAF50)),
                    label: const Text('Set Default',
                        style: TextStyle(
                            color: Color(0xFF4CAF50), fontSize: 12.5)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      backgroundColor: const Color(0xFF4CAF50).withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: () => _delete(context),
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: Colors.red, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.08),
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
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

class _EmptyAddresses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3ED),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.location_off_outlined,
                size: 44, color: Color(0xFFE8631A)),
          ),
          const SizedBox(height: 20),
          const Text('No saved addresses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                  color: Color(0xFF222222))),
          const SizedBox(height: 8),
          const Text('Addresses you save at checkout will appear here.',
              style: TextStyle(fontSize: 13.5, color: Color(0xFFAAAAAA)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}