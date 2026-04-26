import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:uuid/uuid.dart';

class AudioRecordingService {
  AudioRecordingService() : recorderController = RecorderController();

  final RecorderController recorderController;
  final Uuid _uuid = const Uuid();

  Future<bool> hasPermission() => recorderController.checkPermission();

  Future<String> start() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${_uuid.v4()}.m4a';
    recorderController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    await recorderController.record(path: path);
    return path;
  }

  Future<String?> stop() => recorderController.stop(false);

  Future<void> dispose() async {
    recorderController.dispose();
  }
}
