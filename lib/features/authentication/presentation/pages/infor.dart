import 'package:flutter/material.dart';
import 'frontid.dart';
import 'add_manual_info.dart';
import '../../../schedule/presentation/pages/schedule_screen.dart';

class InforScreen extends StatelessWidget {
  const InforScreen({super.key});

  void _showAddInfoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const AddInfoOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
            onPressed: () => _showAddInfoOptions(context),
            tooltip: 'Thêm thông tin',
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 100, 
                        height: 100, 
                        color: Colors.grey, 
                        child: const Center(
                          child: Icon(Icons.person, size: 64, color: Colors.white70),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nguyễn Văn A", 
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    "QR Code",
                                    style: TextStyle(color: Colors.white),
                                  ),
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
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "THÔNG TIN CHI TIẾT",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                
                // Add attendance button here
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                    );
                  },
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text("Điểm danh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: const [
                  InfoCard(
                    icon: Icons.person_outline,
                    title: 'Thông tin cơ bản',
                    items: [
                      InfoItem(label: 'Họ và tên', value: 'Nguyễn Văn A'),
                      InfoItem(label: 'Ngày sinh', value: '01/01/1990'),
                      InfoItem(label: 'Giới tính', value: 'Nam'),
                    ],
                  ),
                  SizedBox(height: 16),
                  InfoCard(
                    icon: Icons.contact_mail_outlined,
                    title: 'Thông tin liên hệ',
                    items: [
                      InfoItem(label: 'Email', value: 'chưa cập nhật'),
                      InfoItem(label: 'Số điện thoại', value: 'chưa cập nhật'),
                      InfoItem(label: 'Địa chỉ', value: 'chưa cập nhật'),
                    ],
                  ),
                  SizedBox(height: 16),
                  InfoCard(
                    icon: Icons.work_outline,
                    title: 'Thông tin khác',
                    items: [
                      InfoItem(label: 'Nghề nghiệp', value: 'chưa cập nhật'),
                      InfoItem(label: 'Nơi làm việc', value: 'chưa cập nhật'),
                    ],
                  ),
                  SizedBox(height: 16),
                  InfoCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'Thông tin điểm danh',
                    items: [
                      InfoItem(label: 'Tháng hiện tại', value: '22/30 ngày'),
                      InfoItem(label: 'Tuần này', value: '4/5 ngày'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<InfoItem> items;
  
  const InfoCard({
    super.key, 
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            ...items,
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  
  const InfoItem({
    super.key, 
    required this.label, 
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: value.contains('chưa cập nhật') ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddInfoOptionsBottomSheet extends StatelessWidget {
  const AddInfoOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Thêm/Chỉnh sửa thông tin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          OptionButton(
            icon: Icons.badge_outlined,
            title: 'Xác minh căn cước công dân',
            subtitle: 'Lấy thông tin từ CCCD',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FrontIdScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          OptionButton(
            icon: Icons.edit_outlined,
            title: 'Chỉnh sửa thông tin',
            subtitle: 'Nhập thông tin cá nhân',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddManualInfoScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}