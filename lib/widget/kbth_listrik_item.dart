
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/kalkulasi_model.dart';

import '../util.dart';

class KbthListrikItem extends StatelessWidget {
  const KbthListrikItem({super.key, required this.onTap, required this.model});

  final VoidCallback onTap;
  final KalkulasiModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6)
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.receipt_long_rounded, color: Colors.blue.shade700, size: 24,),
            ),
            const SizedBox(width: 16,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Util.fromMillisToDate(model.time),
                    style: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    'Periode: ${model.periode}',
                    style: TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        color: Colors.grey.shade600,
                        fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                Util.convertToIdr(model.totalBiaya),
                style: TextStyle(
                    fontFamily: FontColorUtil.fontPoppins,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
