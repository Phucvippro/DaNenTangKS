import 'package:flutter/material.dart';

class InforScreen extends StatelessWidget {
  const InforScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(width: 100, height: 100, color: Colors.grey), // Hình ảnh ở góc trên bên trái
                
                SizedBox(width:10),

                Expanded(child:
                  Column(children:[
                    Text("Tên", style : TextStyle(fontSize :20)),
                    Container(width :100,height :30,color :Colors.green), // Mã QR ở góc trên bên phải 
                  ])
                )
              ],
            ),

            // Thông tin cơ bản ở dưới cùng.
            Expanded(child : ListView(children:[
               ListTile(title :Text('Thông tin cơ bản')),
               ListTile(title :Text('Thông tin khác')),
               // Thêm nhiều thông tin khác nếu cần.
             ]))
          ],
        ),
      ),
    );
  }
}
