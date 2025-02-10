import 'package:fada/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/scan_history_controller.dart';
import '../../core/class/statusrequest.dart';
import '../../data/model/scan_history_model.dart';
import '../../linkapi.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_drawer.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ScanHistoryControllerImp());
    final ScanHistoryControllerImp controller = Get.put(ScanHistoryControllerImp());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Scan History',
        icon: Icons.archive ,
        actions: [
          IconButton(
            icon: const Icon(Icons.update, color: Colors.white),
            onPressed: () {
              controller.getScanHistory();
            },
          ),
        ],),
      drawer: CustomDrawer(),
      body: GetBuilder<ScanHistoryControllerImp>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return _buildShimmerLoading();
          } else if (controller.data.isEmpty) {
            return const Center(child: Text('No scan history available'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.data.length,
            itemBuilder: (context, index) {
              final item = controller.data[index];
              final imageUrl = _getValidImageUrl(item.filePath);
              return _buildHistoryCard(item, imageUrl, context);
            },
          );
        },
      ),
    );
  }

  String? _getValidImageUrl(String? filePath) {
    if (filePath == null || filePath.isEmpty || filePath == 'fail') return null;
    return AppLink.imagesstatic + filePath;
  }

  Widget _buildHistoryCard(ScanHistoryModel item, String? imageUrl, BuildContext context) {
    return Card(
      elevation: 4,

      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showFullDetails(context, item, imageUrl),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              _buildImagePreview(imageUrl),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultRow(item),
                    const SizedBox(height: 8),
                    _buildRecognizedText(item),
                    const SizedBox(height: 8),
                    _buildDateRow(item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.grey[200],
        child: imageUrl != null
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
        )
            : const Icon(Icons.image_not_supported, size: 40),
      ),
    );
  }

  Widget _buildResultRow(ScanHistoryModel item) {
    return Row(
      children: [
        Icon(
          item.result?.startsWith('All Clear') == true ? Icons.check_circle : Icons.warning,
          color: item.result?.startsWith('All Clear') == true ? Colors.green : Colors.orange,
          size: 20,
        )
        ,
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.result ?? 'No result',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRecognizedText(ScanHistoryModel item) {
    final String recognizedContent = item.recognizedText?.isNotEmpty == true
        ? item.recognizedText!
        : 'No text recognized';

    return Text(
      recognizedContent,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 15,
      ),
    );
  }


  Widget _buildDateRow(ScanHistoryModel item) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          _formatDate(item.dateTime),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showFullDetails(BuildContext context, ScanHistoryModel item, String? imageUrl) {
    final bool isAllClear = item.result?.toLowerCase().contains('all clear') ?? false;
    final String fullResult = item.result ?? 'No result available';
    final String recognizedContent = item.recognizedText?.isNotEmpty == true
        ? item.recognizedText!
        : 'No text recognized';

    showModalBottomSheet(
      backgroundColor: const Color(0xffEAF8FB),
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scan Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ]
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 2, color: AppColor.primaryColor),
            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (imageUrl != null)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 100),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isAllClear ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isAllClear ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isAllClear ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                            color: isAllClear ? Colors.green : Colors.red,
                            size: 30,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullResult.split('\n').first,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isAllClear ? Colors.green : Colors.red,
                                  ),
                                ),
                                if (fullResult.contains('\n'))
                                  Text(
                                    fullResult.split('\n').sublist(1).join('\n'),
                                    style: const TextStyle(color: Colors.black87),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailSection('Recognized Text', recognizedContent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

// Keep existing _buildShimmerLoading and _formatDate methods

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const SizedBox(
            height: 112,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return 'Invalid date';
    }
  }


}