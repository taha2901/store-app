import 'package:flutter/material.dart';


class OtpCodeScreen extends StatefulWidget {
  const OtpCodeScreen({super.key});

  @override
  State<OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState extends State<OtpCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top arrow (back button - LTR arrow since it navigates forward)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: Colors.black87, size: 22),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Mail icon in orange circle background
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mail_outline_rounded,
                      color: Color(0xFFE87B2C),
                      size: 36,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Center(
                child: Text(
                  'رمز التحقق',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Center(
                child: Text(
                  'تم إرسال رمز التحقق إلى رقم الجوال',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 6),

              // Phone number
              const Center(
                child: Text(
                  '+966 5x xxx xx89',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // OTP input fields
              Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 58,
                        height: 58,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          onChanged: (val) => _onChanged(val, index),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE87B2C),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Resend section
              Column(
                children: [
                  const Text(
                    'لم يصلك الرمز؟',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // Handle resend
                    },
                    child: const Text(
                      'إعادة الإرسال',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFE87B2C),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Confirm button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle confirmation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDEDED),
                    foregroundColor: Colors.black54,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';


class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Directionality(
          textDirection: TextDirection.ltr,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: Color(0xFFE87B2C), size: 22),
            onPressed: () {},
          ),
        ],
        title: const Text(
          'ملف الشركة',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Logo + Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: const Center(
                        child: Icon(Icons.business_outlined,
                            size: 40, color: Color(0xFFE87B2C)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'شركة الإبداع المعماري',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '.Al Ebdaa Architecture Co',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Basic Info Card
              _SectionCard(
                title: 'المعلومات الأساسية',
                child: Column(
                  children: const [
                    _InfoRow(
                      label: 'السجل التجاري',
                      value: '1010XXXXXX',
                      icon: Icons.description_outlined,
                    ),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'الرقم الضريبي',
                      value: '30XXXXXXXXXX03',
                      icon: Icons.receipt_outlined,
                    ),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'الهاتف',
                      value: '+966 11 234 5678',
                      icon: Icons.phone_outlined,
                    ),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'البريد الإلكتروني',
                      value: 'info@alebdaa.com.sa',
                      icon: Icons.email_outlined,
                    ),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'الموقع الإلكتروني',
                      value: 'www.alebdaa.com.sa',
                      icon: Icons.language_outlined,
                    ),
                    Divider(height: 1),
                    _InfoRow(
                      label: 'العنوان',
                      value: 'الرياض، حي العليا، شارع التحلية',
                      icon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Services Card
              _SectionCard(
                title: 'الخدمات المقدمة',
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _ServiceChip(label: 'التصميم المعماري', selected: true),
                      _ServiceChip(label: 'التصميم الداخلي', selected: true),
                      _ServiceChip(label: 'تنسيق الحدائق', selected: true),
                      _ServiceChip(label: 'إدارة البناء'),
                      _ServiceChip(label: 'الأنظمة الذكية'),
                      _ServiceChip(
                          label: 'الهندسة الكهربائية والميكانيكية'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Portfolio Card
              _SectionCard(
                title: 'معرض الأعمال',
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: const [
                      _PortfolioCard(
                        label: 'تصميم داخلي - جدة',
                        color: Color(0xFFC8A97E),
                      ),
                      _PortfolioCard(
                        label: 'فيلا الملقا - الرياض',
                        color: Color(0xFFB0BEC5),
                      ),
                      _PortfolioCard(
                        label: 'حديقة قصر النخر',
                        color: Color(0xFF81C784),
                      ),
                      _PortfolioCard(
                        label: 'مجمع تجاري - الخبر',
                        color: Color(0xFFEF9A9A),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Certifications Card
              _SectionCard(
                title: 'الشهادات والتراخيص',
                child: Column(
                  children: const [
                    _CertRow(label: 'رخصة مكتب هندسي - البيئة السعودية للمهندسين'),
                    Divider(height: 1),
                    _CertRow(label: 'شهادة ISO 9001:2015'),
                    Divider(height: 1),
                    _CertRow(label: 'عضوية الغرفة التجارية - الرياض'),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Section Card ────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFE87B2C), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Service Chip ─────────────────────────────────────────────────────────────

class _ServiceChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _ServiceChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE87B2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: selected
            ? null
            : Border.all(color: const Color(0xFFD0D0D0), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Portfolio Card ───────────────────────────────────────────────────────────

class _PortfolioCard extends StatelessWidget {
  final String label;
  final Color color;

  const _PortfolioCard({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: color.withOpacity(0.4),
            child: Icon(Icons.image_outlined, color: color, size: 40),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Certification Row ────────────────────────────────────────────────────────

class _CertRow extends StatelessWidget {
  final String label;

  const _CertRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined,
              color: Color(0xFFE87B2C), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
*/