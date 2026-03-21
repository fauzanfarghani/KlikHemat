

import 'package:flutter/material.dart';
import 'package:klik_hemat/font_color_util.dart';
import 'package:klik_hemat/model/kalkulasi_model.dart';
import 'package:klik_hemat/util.dart';
import 'package:klik_hemat/widget/perangkat_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class DetailKbthScreen extends StatefulWidget {
  const DetailKbthScreen({super.key, required this.model});

  final KalkulasiModel model;

  @override
  State<DetailKbthScreen> createState() => _DetailKbthScreenState();
}

class _DetailKbthScreenState extends State<DetailKbthScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text('Laporan Pengunaan Listrik', style: TextStyle(
          fontFamily: FontColorUtil.fontPoppins,
          color: Colors.white,
          fontWeight: FontWeight.w600
        ),),
        actions: [
          IconButton(onPressed: () async {
            final image = await screenshotController.capture();
            final drc = await getApplicationDocumentsDirectory();
            if (image != null) {
              try {
                await Util.saveImage(image);
              } catch(e) {
                print(e);
              }
            } else {
              print('adawda');
            }
            //await FileSaver.instance.saveFile(name: DateTime.now().millisecond.toString(),filePath: drc.path, bytes: image, ext: 'jpeg');
          }, icon: Icon(Icons.save)),
        ],
      ),
      body: Screenshot(

        controller: screenshotController,
        child: Container(
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[700]!, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Util.fromMillisToDate(widget.model.time), style: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),),
                      Text('Periode : ${widget.model.periode}', style: const TextStyle(
                          fontFamily: FontColorUtil.fontPoppins,
                          fontSize: 14,
                          color: Colors.white,
                      ),),
                      Text('Total Kwh : ${widget.model.totalKwh.toStringAsFixed(2)} kWh', style: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        fontSize: 14,
                        color: Colors.white,
                      ),),
                      Text('Total Biaya : ${Util.convertToIdr(widget.model.totalBiaya)}', style: const TextStyle(
                        fontFamily: FontColorUtil.fontPoppins,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                    ],
                  )
                ),
                const SizedBox(height: 8,),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.model.perangkat.length,
                      itemBuilder: (context, index) {
                        return PerangkatItem(onTap: () {}, model: widget.model.perangkat[index],index: index,);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
