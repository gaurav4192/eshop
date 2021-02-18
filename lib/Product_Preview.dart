import 'package:eshop/Helper/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'Helper/Session.dart';
import 'Home.dart';

class ProductPreview extends StatefulWidget {
  final int pos, secPos, index;
  final bool list;
  final String id;
  final List<String> imgList;

  const ProductPreview(
      {Key key,
      this.pos,
      this.secPos,
      this.index,
      this.list,
      this.id,
      this.imgList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => StatePreview();
}

class StatePreview extends State<ProductPreview> {
  int curPos;

  @override
  void initState() {
    super.initState();

    curPos = widget.pos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Hero(
      tag: widget.list
          ? "${widget.id}"
          : "${sectionList[widget.secPos].productList[widget.index].id}${widget.secPos}${widget.index}",
      child: Stack(
        children: <Widget>[
          PageView.builder(
              itemCount: widget.imgList.length,
              controller: PageController(initialPage: curPos),
              onPageChanged: (index) {
                if (mounted)
                  setState(() {
                    curPos = index;
                  });
              },
              itemBuilder: (BuildContext context, int index) {
                return PhotoView(
                    backgroundDecoration: BoxDecoration(color: colors.white),
                    initialScale: PhotoViewComputedScale.contained * 0.9,
                    minScale: PhotoViewComputedScale.contained * 0.9,
                    imageProvider: NetworkImage(widget.imgList[index]));
              }),
          Positioned(
            top: 34.0,
            left: 5.0,
            child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: shadow(),
                  child: Card(
                    elevation: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
          Positioned(
              bottom: 10.0,
              left: 25.0,
              right: 25.0,
              child: SelectedPhoto(
                numberOfDots: widget.imgList.length,
                photoIndex: curPos,
              )),
        ],
      ),
    ));
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 3.0, end: 3.0),
        child: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4.0)),
        ),
      ),
    );
  }

  Widget _activePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 5.0, end: 5.0),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }
}
