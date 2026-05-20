

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── Model ─────────────────────────────────────────────────────────────────────
class ComplaintModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String phone;
  final String issueType;
  final String description;
  final String status;
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.phone,
    required this.issueType,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory ComplaintModel.fromMap(String id, Map<String, dynamic> data) {
    return ComplaintModel(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      phone: data['phone'] ?? '',
      issueType: data['issueType'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'userEmail': userEmail,
    'phone': phone,
    'issueType': issueType,
    'description': description,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  };
}

// ── Complaint Service ─────────────────────────────────────────────────────────
class ComplaintService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _complaints => _db.collection('complaints');

  Future<void> submitComplaint({
    required String phone,
    required String issueType,
    required String description,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    await _complaints.add({
      'userId': user.uid,
      'userName': user.displayName ?? user.email?.split('@').first ?? 'User',
      'userEmail': user.email ?? '',
      'phone': phone,
      'issueType': issueType,
      'description': description,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<ComplaintModel>> getUserComplaints() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _complaints
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((d) =>
          ComplaintModel.fromMap(d.id, d.data() as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }
}

// ── Issue Types ───────────────────────────────────────────────────────────────
class _IssueType {
  final String label;
  final IconData icon;
  const _IssueType(this.label, this.icon);
}

const _issueTypes = [
  _IssueType('Late Delivery', Icons.schedule_rounded),
  _IssueType('Missing Item', Icons.inventory_2_rounded),
  _IssueType('Wrong Item', Icons.swap_horiz_rounded),
  _IssueType('Quality Issue', Icons.thumb_down_rounded),
  _IssueType('Refund Issue', Icons.currency_rupee_rounded),
  _IssueType('App Problem', Icons.phone_android_rounded),
  _IssueType('Payment Issue', Icons.payment_rounded),
  _IssueType('Other', Icons.more_horiz_rounded),
];

// ── Raise Complaint Page ──────────────────────────────────────────────────────
class RaiseComplaintPage extends StatefulWidget {
  const RaiseComplaintPage({super.key});

  @override
  State<RaiseComplaintPage> createState() => _RaiseComplaintPageState();
}

class _RaiseComplaintPageState extends State<RaiseComplaintPage>
    with SingleTickerProviderStateMixin {
  static const _orange = Color(0xffe07b39);
  static const _bg = Color(0xffF5F6F8);

  final ComplaintService _service = ComplaintService();
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String? _selectedIssue;
  bool _submitting = false;
  bool _submitted = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final user = FirebaseAuth.instance.currentUser;
    if (user?.phoneNumber != null) {
      _phoneCtrl.text = user!.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIssue == null) {
      _showSnack('Please select an issue type');
      return;
    }
    setState(() => _submitting = true);
    try {
      await _service.submitComplaint(
        phone: _phoneCtrl.text.trim(),
        issueType: _selectedIssue!,
        description: _descCtrl.text.trim(),
      );
      setState(() {
        _submitting = false;
        _submitted = true;
      });
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _submitted = false;
          _selectedIssue = null;
          _descCtrl.clear();
        });
        _tabController.animateTo(1);
      }
    } catch (e) {
      setState(() => _submitting = false);
      _showSnack('Error: ${e.toString()}');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: _submitted ? _buildSuccessState() : _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe07b39), Color(0xffcf6a2a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      title: const Text(
        'Help & Support',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        labelStyle:
        const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        tabs: const [
          Tab(text: 'Raise Complaint'),
          Tab(text: 'My Complaints'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildFormTab(),
        _buildMyComplaintsTab(),
      ],
    );
  }

  Widget _buildFormTab() {
    return Form(
      key: _formKey,
      child: ListView(
        // FIX: increased bottom padding so info note is never clipped
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          _buildHeaderBanner(),
          const SizedBox(height: 16),
          _buildSectionTitle('What went wrong?'),
          const SizedBox(height: 10),
          _buildIssueGrid(),
          const SizedBox(height: 16),
          _buildSectionTitle('Contact Number'),
          const SizedBox(height: 10),
          _buildPhoneField(),
          const SizedBox(height: 16),
          _buildSectionTitle('Describe Your Issue'),
          const SizedBox(height: 10),
          _buildDescriptionField(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
          const SizedBox(height: 16),
          // FIX: info note now has extra bottom margin so it's fully visible
          _buildInfoNote(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xffe07b39).withOpacity(0.12),
            const Color(0xffe07b39).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffe07b39).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffe07b39).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: Color(0xffe07b39), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We\'re Here to Help!',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xff1a1a1a),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Our team responds within 2–4 hours',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff333333),
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildIssueGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: _issueTypes.length,
      itemBuilder: (ctx, i) {
        final issue = _issueTypes[i];
        final selected = _selectedIssue == issue.label;
        return GestureDetector(
          onTap: () => setState(() => _selectedIssue = issue.label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected ? const Color(0xffe07b39) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? const Color(0xffe07b39)
                    : const Color(0xffEEEEEE),
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: const Color(0xffe07b39).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  issue.icon,
                  size: 24,
                  color: selected ? Colors.white : const Color(0xffe07b39),
                ),
                const SizedBox(height: 6),
                Text(
                  issue.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xff555555),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        controller: _phoneCtrl,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 14, color: Color(0xff1a1a1a)),
        decoration: InputDecoration(
          hintText: 'e.g. +92 (345) 456-7890',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xffFFF3E8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.phone_rounded,
                color: Color(0xffe07b39), size: 18),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'Phone is required';
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        controller: _descCtrl,
        maxLines: 5,
        maxLength: 500,
        style: const TextStyle(fontSize: 14, color: Color(0xff333333)),
        decoration: InputDecoration(
          hintText:
          'Describe your issue in detail — the more info, the faster we can help...',
          hintStyle:
          TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
          counterStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
        ),
        validator: (v) {
          if (v == null || v.trim().length < 10) {
            return 'Please describe your issue (min 10 characters)';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _submitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffe07b39),
          disabledBackgroundColor:
          const Color(0xffe07b39).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _submitting
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Submit Complaint',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIX: info note — full width, properly visible, no clipping
  Widget _buildInfoNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xffFFF3E8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffe07b39).withOpacity(0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline_rounded,
                color: Color(0xffe07b39), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your complaint will be tracked and you\'ll receive a response via your registered email within 2–4 business hours.',
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xffcf6a2a),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xffFFF3E8),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check_circle_rounded,
                    size: 52, color: Color(0xffe07b39)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Complaint Submitted!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xff1a1a1a),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We\'ve received your complaint and our team will get back to you within 2–4 hours.',
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
            ),
            const SizedBox(height: 8),
            const LinearProgressIndicator(
              color: Color(0xffe07b39),
              backgroundColor: Color(0xffFFF3E8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyComplaintsTab() {
    return StreamBuilder<List<ComplaintModel>>(
      stream: _service.getUserComplaints(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xffe07b39)));
        }
        if (snap.hasError || !snap.hasData) {
          return _buildNoComplaintsState();
        }
        final complaints = snap.data!;
        if (complaints.isEmpty) return _buildNoComplaintsState();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: complaints.length,
          itemBuilder: (ctx, i) =>
              _ComplaintCard(complaint: complaints[i]),
        );
      },
    );
  }

  Widget _buildNoComplaintsState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xffFFF3E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_rounded,
                size: 48, color: Color(0xffe07b39)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No complaints yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your submitted complaints will appear here',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// ── Complaint Card ────────────────────────────────────────────────────────────
class _ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  const _ComplaintCard({required this.complaint});

  Color _statusColor(String status) {
    switch (status) {
      case 'resolved':
        return const Color(0xff2E7D32);
      case 'in_review':
        return const Color(0xff1565C0);
      default:
        return const Color(0xffe07b39);
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'resolved':
        return 'Resolved';
      case 'in_review':
        return 'In Review';
      default:
        return 'Pending';
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'resolved':
        return Icons.check_circle_rounded;
      case 'in_review':
        return Icons.visibility_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(complaint.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xffFFF3E8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.report_problem_rounded,
                    color: Color(0xffe07b39), size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  complaint.issueType,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xff1a1a1a),
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon(complaint.status), size: 12, color: color),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel(complaint.status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (complaint.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              complaint.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[600], height: 1.4),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 13, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(
                _timeAgo(complaint.createdAt),
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}