import 'dart:async';
import 'dart:io';

import 'package:ardrive/blocs/blocs.dart';
import 'package:ardrive/models/models.dart';
import 'package:ardrive/services/services.dart';
import 'package:ardrive/theme/theme.dart';
import 'package:cryptography/cryptography.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';

import 'components.dart';

Future<void> promptToDownloadProfileFile({
  required BuildContext context,
  required String driveId,
  required String fileId,
}) =>
    showDialog(
      context: context,
      builder: (_) => BlocProvider<FileDownloadCubit>(
        create: (_) => ProfileFileDownloadCubit(
          driveId: driveId,
          fileId: fileId,
          profileCubit: context.read<ProfileCubit>(),
          driveDao: context.read<DriveDao>(),
          arweave: context.read<ArweaveService>(),
        ),
        child: FileDownloadDialog(),
      ),
    );

Future<void> promptToDownloadSharedFile({
  required BuildContext context,
  required String fileId,
  SecretKey? fileKey,
}) =>
    showDialog(
      context: context,
      builder: (_) => BlocProvider<FileDownloadCubit>(
        create: (_) => SharedFileDownloadCubit(
          fileId: fileId,
          fileKey: fileKey,
          arweave: context.read<ArweaveService>(),
        ),
        child: FileDownloadDialog(),
      ),
    );

class FileDownloadDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocConsumer<FileDownloadCubit, FileDownloadState>(
        listener: (context, state) async {
          if (state is FileDownloadSuccess) {
            String path;
            if (Platform.isAndroid) {
              final dir = await getExternalStorageDirectory();
              path = dir!.path;
            } else {
              final dir = await getApplicationDocumentsDirectory();
              path = dir.path;
            }

            final _appDocDirFolder = Directory('$path/ardrive');
            if (await _appDocDirFolder.exists()) {
              final file = File('${_appDocDirFolder.path}/${state.file.name}');
              print(file.path);
              unawaited(file.writeAsBytes(state.file.bytes!));

              Navigator.pop(context);
            } else {
              final _appDocDirNewFolder = await _appDocDirFolder.create();
              final file =
                  File('${_appDocDirNewFolder.path}/${state.file.name}');
              print(file.path);
              unawaited(file.writeAsBytes(state.file.bytes!));
              Navigator.pop(context);
            }
          }
        },
        builder: (context, state) {
          if (state is FileDownloadStarting) {
            return AppDialog(
              dismissable: false,
              title: 'Downloading file...',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            );
          } else if (state is FileDownloadInProgress) {
            return AppDialog(
              dismissable: false,
              title: 'Downloading file...',
              content: SizedBox(
                width: kMediumDialogWidth,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    state.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(filesize(state.totalByteCount)),
                  trailing: const CircularProgressIndicator(),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    context.read<FileDownloadCubit>().abortDownload();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          } else if (state is FileDownloadFailure) {
            return AppDialog(
              dismissable: false,
              title: 'File download failed',
              content: SizedBox(
                width: kMediumDialogWidth,
                child: Text(
                    'This can happen if the file was only uploaded recently. Please try again later.'),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      );
}
