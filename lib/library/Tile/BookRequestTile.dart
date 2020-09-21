import 'package:ere_manager/library/model/BookRequest.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class BookRequestTile extends StatefulWidget {
  int index;
  BookRequest bookRequest;
  double width;
  double height;
  Function refresh;

  BookRequestTile({this.index, this.bookRequest, this.width, this.height, this.refresh});

  _BookRequestTileState createState() => _BookRequestTileState();
}

class _BookRequestTileState extends State<BookRequestTile> {
  @override
  Widget build(BuildContext context) {
    double tile_padding = widget.width * 0.0075;
    double tile_height = widget.height * 0.05;
    double fontsize = widget.width * 0.037;

    return Row(
      children: [
        Checkbox(
          value: widget.bookRequest.isChecked,
          onChanged: (_) {
            widget.bookRequest.isChecked = !widget.bookRequest.isChecked;
            widget.refresh();
          },
          checkColor: ERE_YELLOW,
          activeColor: ERE_BLACK,
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.07,
          height: tile_height,
          child: Text(
            '${widget.index}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.3,
          height: tile_height,
          child: Text(
            widget.bookRequest.title,
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.3,
          height: tile_height,
          child: Text(
            widget.bookRequest.author,
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.2,
          height: tile_height,
          child: Text(
            widget.bookRequest.requesterName,
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        )
      ],
    );
  }
}
