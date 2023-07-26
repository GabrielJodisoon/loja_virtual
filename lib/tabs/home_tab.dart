import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),

          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );

    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "LANÇAMENTOS",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('home')
                  .orderBy('pos')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: GridView.custom(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        repeatPattern: QuiltedGridRepeatPattern.mirrored,
                        pattern: [
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 2),
                          QuiltedGridTile(2, 1),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                        ],
                      ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data!.docs[index]['image'],
                          fit: BoxFit.cover,
                        ),
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  );

                  // -- outra forma de realizar --
                  // return SliverMasonryGrid.count(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 1,
                  //   crossAxisSpacing: 1,
                  //   itemBuilder: (context, index) {
                  //
                  //     return FadeInImage.memoryNetwork(
                  //         placeholder: kTransparentImage,
                  //         image: snapshot.data!.docs[index]['image'],
                  //     fit: BoxFit.cover,);
                  //   },
                  //   childCount: snapshot.data!.docs.length,
                  // );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
