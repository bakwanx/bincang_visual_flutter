import 'package:bincang_visual_flutter/src/domain/entities/banner_entity.dart';
import 'package:bincang_visual_flutter/utils/extension/context_extension.dart';
import 'package:bincang_visual_flutter/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class BannerItem extends StatelessWidget {
  final BannerEntity bannerEntity;

  const BannerItem({super.key, required this.bannerEntity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width() * 0.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(bannerEntity.img, width: 300, height: 300),
          Text(
            bannerEntity.title,
            style: AppTextStyle.titleMedium,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Text(
              bannerEntity.description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
