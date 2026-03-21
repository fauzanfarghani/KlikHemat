import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/rekomendasi_model.dart';

class RekomendasiItem extends StatelessWidget {
  const RekomendasiItem({super.key, required this.onTap, required this.model});

  final VoidCallback onTap;
  final RekomendasiModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: model.picture,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Image.asset(
                      'asset/images/p_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (_, __, ___) => Image.asset(
                      'asset/images/p_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: FontColorUtil.fontPoppins,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6,),
                    Text(
                      model.desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: FontColorUtil.fontPoppins,
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          height: 1.3
                          ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: Colors.blue.shade400, size: 14,),
                        const SizedBox(width: 4,),
                        Expanded(
                          child: Text(
                            model.tanggal,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: FontColorUtil.fontPoppins,
                                color: Colors.black45,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
