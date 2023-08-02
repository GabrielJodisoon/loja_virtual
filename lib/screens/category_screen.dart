import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';
import 'package:loja_virtual/widgets/cart_button.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            floatingActionButton: CartButton(),
            appBar: AppBar(
              title: Text(snapshot['title']),
              centerTitle: true,
              bottom: TabBar(indicatorColor: Colors.black, tabs: [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ]),
            ),
            body: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("products")
                  .doc(snapshot.id)
                  .collection("items")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        GridView.builder(
                            padding: EdgeInsets.all(4),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                    childAspectRatio: 0.65),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              ProductData data = ProductData.fromDocument(snapshot.data!.docs[index]);
                              data.category = this.snapshot.id;

                              return ProductTile(
                                type: 'grid',
                                data: data,
                                  );
                            }),
                        ListView.builder(
                            padding: EdgeInsets.all(4),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index){
                              ProductData data = ProductData.fromDocument(snapshot.data!.docs[index]);
                              data.category = this.snapshot.id;
                              return ProductTile(
                                type: 'list',
                                data: data,
                              );
                            })
                      ]);
                }
              },
            )));
  }
}
