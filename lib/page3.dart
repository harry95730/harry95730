import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

/// Represents Homepage for Navigation
class HomePage extends StatefulWidget {
  final String linkforopening;
  final bool ofon;
  const HomePage({super.key, required this.linkforopening, required this.ofon});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  Uint8List? _documentBytes;
  OverlayEntry? _overlayEntry;
  double yOffset = 0.0;
  double xOffset = 0.0;
  final Color _contextMenuColor = const Color(0xFFFFFFFF);
  final Color _textColor = const Color(0xFF000000);

  @override
  void initState() {
    if (widget.ofon) {
      getPdfBytes1(widget.linkforopening);
    } else {
      getPdfBytesFromWeb(widget.linkforopening);
    }
    super.initState();
  }

  void getPdfBytes1(String linkforopenin) async {
    try {
      String pdfPath =
          '/storage/emulated/0/Android/data/com.example.flutter_application_1/files/data/user/0/com.example.flutter_application_1/files/$linkforopenin.pdf';
      File pdfFile = File(pdfPath);
      Uint8List bytes = await pdfFile.readAsBytes();
      final ByteData bytes1 = ByteData.sublistView(Uint8List.fromList(bytes));
      _documentBytes = bytes1.buffer.asUint8List();
      setState(() {});
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Get the PDF document as bytes from local project asset
  void getPdfBytes(String linkforopenin) async {
    try {
      String pdfPath =
          '/storage/emulated/0/Android/data/com.example.flutter_application_1/files/data/user/0/com.example.flutter_application_1/files/$linkforopenin';

      final ByteData bytes = await DefaultAssetBundle.of(context).load(pdfPath);
      _documentBytes = bytes.buffer.asUint8List();
      setState(() {});
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Get the PDF document as bytes from internet URL
  void getPdfBytesFromWeb(String link) async {
    _documentBytes = await http.readBytes(Uri.parse(link));
    setState(() {});
  }

  ///Add the annotation in PDF document
  Widget _addAnnotation(String? annotationType, String? selectedText) {
    return SizedBox(
      height: 30,
      width: 100,
      child: RawMaterialButton(
        onPressed: () async {
          _checkAndCloseContextMenu();
          await Clipboard.setData(ClipboardData(text: selectedText!));
          _drawAnnotation(annotationType);
        },
        child: Text(
          annotationType!,
          style: TextStyle(
              color: _textColor,
              fontSize: 10,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  ///Draw the annotation in PDF document
  void _drawAnnotation(String? annotationType) {
    final PdfDocument document = PdfDocument(inputBytes: _documentBytes);
    switch (annotationType) {
      case 'Highlight':
        {
          _pdfViewerKey.currentState!
              .getSelectedTextLines()
              .forEach((pdfTextLine) {
            final PdfPage _page = document.pages[pdfTextLine.pageNumber];
            final PdfRectangleAnnotation rectangleAnnotation =
                PdfRectangleAnnotation(
                    pdfTextLine.bounds, 'Highlight Annotation',
                    author: 'Syncfusion',
                    color: PdfColor.fromCMYK(0, 0, 255, 0),
                    innerColor: PdfColor.fromCMYK(0, 0, 255, 0),
                    opacity: 0.5);
            _page.annotations.add(rectangleAnnotation);
            _page.annotations.flattenAllAnnotations();
            xOffset = _pdfViewerController.scrollOffset.dx;
            yOffset = _pdfViewerController.scrollOffset.dy;
          });
          final List<int> bytes = document.saveSync();
          setState(() {
            _documentBytes = Uint8List.fromList(bytes);
          });
        }
        break;
      case 'Underline':
        {
          _pdfViewerKey.currentState!
              .getSelectedTextLines()
              .forEach((pdfTextLine) {
            final PdfPage _page = document.pages[pdfTextLine.pageNumber];
            final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
              [
                pdfTextLine.bounds.left.toInt(),
                (document.pages[pdfTextLine.pageNumber].size.height -
                        pdfTextLine.bounds.bottom)
                    .toInt(),
                pdfTextLine.bounds.right.toInt(),
                (document.pages[pdfTextLine.pageNumber].size.height -
                        pdfTextLine.bounds.bottom)
                    .toInt()
              ],
              'Underline Annotation',
              author: 'Syncfusion',
              innerColor: PdfColor(0, 255, 0),
              color: PdfColor(0, 255, 0),
            );
            _page.annotations.add(lineAnnotation);
            _page.annotations.flattenAllAnnotations();
            xOffset = _pdfViewerController.scrollOffset.dx;
            yOffset = _pdfViewerController.scrollOffset.dy;
          });
          final List<int> bytes = document.saveSync();
          setState(() {
            _documentBytes = Uint8List.fromList(bytes);
          });
        }
        break;
      case 'Strikethrough':
        {
          _pdfViewerKey.currentState!
              .getSelectedTextLines()
              .forEach((pdfTextLine) {
            final PdfPage _page = document.pages[pdfTextLine.pageNumber];
            final PdfLineAnnotation lineAnnotation = PdfLineAnnotation(
              [
                pdfTextLine.bounds.left.toInt(),
                ((document.pages[pdfTextLine.pageNumber].size.height -
                            pdfTextLine.bounds.bottom) +
                        (pdfTextLine.bounds.height / 2))
                    .toInt(),
                pdfTextLine.bounds.right.toInt(),
                ((document.pages[pdfTextLine.pageNumber].size.height -
                            pdfTextLine.bounds.bottom) +
                        (pdfTextLine.bounds.height / 2))
                    .toInt()
              ],
              'Strikethrough Annotation',
              author: 'Syncfusion',
              innerColor: PdfColor(255, 0, 0),
              color: PdfColor(255, 0, 0),
            );
            _page.annotations.add(lineAnnotation);
            _page.annotations.flattenAllAnnotations();
            xOffset = _pdfViewerController.scrollOffset.dx;
            yOffset = _pdfViewerController.scrollOffset.dy;
          });
          final List<int> bytes = document.saveSync();
          setState(() {
            _documentBytes = Uint8List.fromList(bytes);
          });
        }
        break;
    }
  }

  /// Show Context menu with annotation options.
  void _showContextMenu(
    BuildContext context,
    PdfTextSelectionChangedDetails? details,
  ) {
    final RenderBox? renderBoxContainer =
        context.findRenderObject()! as RenderBox;
    if (renderBoxContainer != null) {
      const double _kContextMenuHeight = 90;
      const double _kContextMenuWidth = 100;
      const double _kHeight = 18;
      final Offset containerOffset = renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
      );
      if (details != null &&
              containerOffset.dy < details.globalSelectedRegion!.topLeft.dy ||
          (containerOffset.dy <
                  details!.globalSelectedRegion!.center.dy -
                      (_kContextMenuHeight / 2) &&
              details.globalSelectedRegion!.height > _kContextMenuWidth)) {
        double top = 0.0;
        double left = 0.0;
        final Rect globalSelectedRect = details.globalSelectedRegion!;
        if ((globalSelectedRect.top) > MediaQuery.of(context).size.height / 2) {
          top = globalSelectedRect.topLeft.dy +
              details.globalSelectedRegion!.height +
              _kHeight;
          left = globalSelectedRect.bottomLeft.dx;
        } else {
          top = globalSelectedRect.height > _kContextMenuWidth
              ? globalSelectedRect.center.dy - (_kContextMenuHeight / 2)
              : globalSelectedRect.topLeft.dy +
                  details.globalSelectedRegion!.height +
                  _kHeight;
          left = globalSelectedRect.height > _kContextMenuWidth
              ? globalSelectedRect.center.dx - (_kContextMenuWidth / 2)
              : globalSelectedRect.bottomLeft.dx;
        }
        final OverlayState? _overlayState =
            Overlay.of(context, rootOverlay: true);
        _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: top,
            left: left,
            child: Container(
              decoration: BoxDecoration(
                color: _contextMenuColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.14),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              constraints: const BoxConstraints.tightFor(
                  width: _kContextMenuWidth, height: _kContextMenuHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _addAnnotation('Highlight', details.selectedText),
                  _addAnnotation('Underline', details.selectedText),
                  _addAnnotation('Strikethrough', details.selectedText),
                ],
              ),
            ),
          ),
        );
        _overlayState?.insert(_overlayEntry!);
      }
    }
  }

  /// Check and close the context menu.
  void _checkAndCloseContextMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
      ),
      body: _documentBytes != null
          ? SfPdfViewer.memory(
              _documentBytes!,
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                _pdfViewerController.jumpTo(xOffset: xOffset, yOffset: yOffset);
              },
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null && _overlayEntry != null) {
                  _checkAndCloseContextMenu();
                } else if (details.selectedText != null &&
                    _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
            )
          : Container(),
    );
  }
}
