import 'dart:convert';

import 'package:ardrive/blocs/profile/profile_cubit.dart';
import 'package:ardrive/models/models.dart';
import 'package:ardrive/services/arweave/arweave.dart';
import 'package:ardrive/services/crypto/entities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moor/moor.dart';

class FilePreview extends StatefulWidget {
  final String networkPath;
  final int fileSize;
  final String fileExtension;
  final DriveDao _driveDao;
  final ArweaveService _arweave;
  final ProfileCubit _profileCubit;
  final String driveId;
  final String fileId;

  FilePreview({
    Key? key,
    required this.networkPath,
    required this.fileSize,
    required this.fileExtension,
    required this.driveId,
    required this.fileId,
    required DriveDao driveDao,
    required ArweaveService arweave,
    required ProfileCubit profileCubit,
  })  : _driveDao = driveDao,
        _arweave = arweave,
        _profileCubit = profileCubit,
        super(key: key);

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

enum ViewType { none, unsupported_type, downloading, done, fail, too_large }
final imageExtensions = ['png', 'jpg', 'gif', 'tiff', 'tif', 'bmp'];
final textDataExtensions = ['txt', 'json'];
final acceptedExtensions = [...imageExtensions, ...textDataExtensions];

class _FilePreviewState extends State<FilePreview> {
  static const int MAX_FILE_PREVIEW_SIZE_BYTES = 26214400;
  final double MAX_FILE_PREVIEW_SIZE_MB =
      MAX_FILE_PREVIEW_SIZE_BYTES / 1024 / 1024;
  ViewType isDownloading = ViewType.none;
  Uint8List content = Uint8List(0);

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      getFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: getDisplayWidget(),
    );
  }

  Widget getDisplayWidget() {
    if (isDownloading == ViewType.done) {
      return _buildFilePreviewWidget();
    } else if (isDownloading == ViewType.unsupported_type) {
      return _buildUnsupportedTypeWidget();
    } else {
      return _buildInProgressWidget();
    }
  }

  Widget _buildFilePreviewWidget() {
    if (imageExtensions.contains(widget.fileExtension) && content.isNotEmpty) {
      return Image.memory(content, alignment: Alignment.topCenter, errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Text('Could not load image');
      });
    } else if (content.isNotEmpty) {
      return Text(utf8.decode(content));
    }
    return Text('placeholder');
  }

  Widget _buildFileTooLargeWidget() {
    return Text(
        'File Preview not supported for files over ${MAX_FILE_PREVIEW_SIZE_MB}MB, please download the file to view');
  }

  Widget _buildUnsupportedTypeWidget() {
    return Text(
        'File Preview not supported for ${widget.fileExtension}, please download the file to view');
  }

  Widget _buildInProgressWidget() {
    return Container(
        width: 50,
        height: 50,
        alignment: Alignment.topCenter,
        child: CircularProgressIndicator());
  }

  Future<void> getFile() async {
    final validExtension = acceptedExtensions.contains(widget.fileExtension);
    if (validExtension && widget.fileSize < MAX_FILE_PREVIEW_SIZE_BYTES) {
      final dataRes = await http.get(Uri.parse(widget.networkPath));
      late Uint8List dataBytes;
      final drive =
          await widget._driveDao.driveById(driveId: widget.driveId).getSingle();
      if (drive.isPublic) {
        dataBytes = dataRes.bodyBytes;
      } else if (drive.isPrivate) {
        final profile = widget._profileCubit.state as ProfileLoggedIn;
        final file = await widget._driveDao
            .fileById(driveId: widget.driveId, fileId: widget.fileId)
            .getSingle();
        final dataTx =
            await (widget._arweave.getTransactionDetails(file.dataTxId));

        final fileKey = await widget._driveDao
            .getFileKey(widget.driveId, widget.fileId, profile.cipherKey);
        if (dataTx != null) {
          dataBytes =
              await decryptTransactionData(dataTx, dataRes.bodyBytes, fileKey!);
        }
      }
      setState(() {
        content = dataBytes; // Images can just be fetched raw
      });
    } else {}

    setState(() {
      if (mounted) {
        if (!validExtension) {
          isDownloading = ViewType.unsupported_type;
        } else if (widget.fileSize > MAX_FILE_PREVIEW_SIZE_BYTES) {
          isDownloading = ViewType.too_large;
        } else {
          isDownloading = ViewType.done;
        }
      }
    });
  }
}
