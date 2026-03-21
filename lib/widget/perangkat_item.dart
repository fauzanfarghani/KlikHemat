import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/perangkat_model.dart';

class PerangkatItem extends StatelessWidget {
  const PerangkatItem({super.key, required this.onTap, required this.model, required this.index});

  final VoidCallback onTap;
  final PerangkatModel model;
  final int index;

  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'gadget': return Icons.smartphone;
      case 'ac': return Icons.ac_unit;
      case 'kulkas': return Icons.kitchen;
      case 'kipas angin': return Icons.air;
      case 'kompor listrik': return Icons.microwave;
      default: return Icons.electrical_services;
    }
  }

  Widget _buildMetric(IconData icon, Color iconColor, String value, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18,),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),),
            const SizedBox(height: 2,),
            Text(label, style: const TextStyle(fontFamily: FontColorUtil.fontPoppins, fontSize: 11, color: Colors.grey),),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6)
            )
          ]
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4)
                      )
                    ]
                  ),
                  child: Icon(
                    _getDeviceIcon(model.jenisPerangkat),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.namaPerangkat,
                        style: const TextStyle(
                          fontFamily: FontColorUtil.fontPoppins,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.jenisPerangkat,
                        style: const TextStyle(
                          fontFamily: FontColorUtil.fontPoppins,
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 28,),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            Row(
              children: [
                Expanded(child: _buildMetric(Icons.bolt_rounded, Colors.orange.shade600, '${model.daya} W', 'Daya Listrik')),
                Container(width: 1, height: 40, color: Colors.grey.shade100,),
                const SizedBox(width: 16,),
                Expanded(child: _buildMetric(Icons.schedule_rounded, Colors.blue.shade600, '${model.durasiHarian} Jam', 'Durasi Harian')),
              ],
            ),
          ],
        )
      ),
    );
  }
}
