#import "PluginsPlugin.h"

CPRCEN_engine *eng;
typedef struct user_data {
    AVAudioPlayer *player;
} user_data;










/* Callback function

 The callback function is fired for every phrase returned by the
 synthesiser.  Audio is played using an AVAudioPlayer.  Playback
 is in a separate thread and allows synthesis to continue.

 To track the changes in status, we pass a pointer to a user data
 structure containing the audio player and the last audio buffer.
 */
void channel_callback(CPRC_abuf * abuf, void * userdata) {
    /* Transcription buffer, holds information on phone timings,
     markers and words.
     */
    printf("INFO: synthesised in %.3fs\n");
    CPRC_abuf * abuf_done;
    const CPRC_abuf_trans * trans;
    const char * name;
    float start, end;
    user_data * data = (user_data *) userdata;

    int i;
    int trans_mk = CPRC_abuf_trans_mk(abuf);
    int trans_done = CPRC_abuf_trans_done(abuf);
    /* Process the transcription buffer items and print information. */
    for(i = trans_mk; i < trans_done; i++) {
        trans = CPRC_abuf_get_trans(abuf, i);
        start = CPRC_abuf_trans_start(trans);
        end = CPRC_abuf_trans_end(trans);
        name = CPRC_abuf_trans_name(trans);
        if (CPRC_abuf_trans_type(trans) == CPRC_ABUF_TRANS_PHONE) {
            printf("INFO: phoneme: %.3f %.3f %s\n", start, end, name);
        } else if (CPRC_abuf_trans_type(trans) == CPRC_ABUF_TRANS_WORD) {
            printf("INFO: word: %.3f %.3f %s\n", start, end, name);
        } else if (CPRC_abuf_trans_type(trans) == CPRC_ABUF_TRANS_MARK) {
            printf("INFO: marker: %.3f %.3f %s\n", start, end, name);
        } else if (CPRC_abuf_trans_type(trans) == CPRC_ABUF_TRANS_ERROR) {
            printf("ERROR: could not retrieve transcription at '%d'", i);
        }
    }
    // Convert the audio buffer into a sequence of bytes with a RIFF header,
    // this allows an audio player to be initialised from memory.  This
    // is allocated memory, so the buffer needs cleaning up later.
    abuf_done = CPRC_abuf_extract(abuf, CPRC_abuf_wav_mk(abuf), CPRC_abuf_added_wav_sz(abuf));
    CPTP_fixedbuf *riff = CPRC_riff_buffer(abuf_done);
    // Create an audio data object from our RIFF bytes
    NSData *soundData = [[NSData alloc] initWithBytes: (const void *)riff->_buffer length: riff->_size];
    NSError *playerError = nil;
    // Create an audio player
    AVAudioPlayer *avPlayer =
    [[AVAudioPlayer alloc] initWithData: soundData
                                      error: &playerError];
    if (!avPlayer) {
        // Check for player problems
        NSInteger messageCode = [playerError code];
        NSString *messageString = [playerError localizedDescription];
        printf("ERROR: could not play back audio, code '%d' message '%s'\n", messageCode, [messageString UTF8String]);
    } else {
        // The delegate is used to clean up the player when it is finished,
        // it can also be used to update buttons in a GUI etc.

        // Initialize the player
        [avPlayer prepareToPlay];

        // Wait for the previous player to complete
        if(data->player) {
            while([data->player isPlaying]) {
                [NSThread sleepForTimeInterval:.01];
            }
        }
        // Kick off playback - note that playback is performed in
        // in a separate thread, so this function will return
        // before playback is completed.
        data->player = avPlayer;
        [avPlayer play];
    }
    // Clean up
    CPTP_fixedbuf_delete(riff);
    CPRC_abuf_delete(abuf_done);
}





@implementation PluginsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins"
            binaryMessenger:[registrar messenger]];
  PluginsPlugin* instance = [[PluginsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

      if ([@"cereEngInit" isEqualToString:call.method]) {

        result(@"done");
      }


      if ([@"cereSpeak" isEqualToString:call.method]) {
dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    //Background Thread

          user_data * ud = malloc(sizeof(user_data));
          NSString *voicePathNS = [[NSBundle mainBundle] pathForResource:@"tts" ofType:@"voice"];
          NSString *licensePathNS = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"lic"];
          const char *voicePath = [voicePathNS UTF8String];
          const char *licensePath = [licensePathNS UTF8String];
          eng = CPRCEN_engine_load(voicePath, licensePath, NULL,NULL,NULL);
    NSString *textNS = call.arguments[@"text"];
      const char *test = [textNS UTF8String];


     CPRCEN_channel_handle chan = CPRCEN_engine_open_default_channel(eng);
        // Set our callback function and user data
    CPRCEN_engine_set_callback(eng, chan, ud, (cprcen_channel_callback)channel_callback);
    // Synthesise - audio is output phrase-by-phrase to the callback function.
    // The final argument controls the flushing of the output.
    CPRCEN_channel_set_pipe_length(eng, chan, 0);
    CPRCEN_engine_channel_speak(eng, chan, test, strlen(test), 1);
    // Wait for playback of the final audio to finish
    if (ud->player) {
        while([ud->player isPlaying]) {
            [NSThread sleepForTimeInterval:.01];
        }
    }
    //
    // Clean up
    //
    CPRCEN_engine_channel_close(eng, chan);
    free(ud);
});




    result(@"done");
  } else {
    result(FlutterMethodNotImplemented);
  }
}
@end




// #import "PluginsPlugin.h"
//
//
// @implementation PluginsPlugin
// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   FlutterMethodChannel* channel = [FlutterMethodChannel
//       methodChannelWithName:@"plugins"
//             binaryMessenger:[registrar messenger]];
//   PluginsPlugin* instance = [[PluginsPlugin alloc] init];
//   [registrar addMethodCallDelegate:instance channel:channel];
// }
//
//
//
//
//
// - (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//
//       if ([@"cereEngInit" isEqualToString:call.method]) {
//
//         result(@"done");
//       }
//
//
//       if ([@"cereSpeak" isEqualToString:call.method]) {
//           NSString *voicePathNS = [[NSBundle mainBundle] pathForResource:@"tts" ofType:@"voice"];
//           NSString *licensePathNS = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"lic"];
//           const char *voicePath = [voicePathNS UTF8String];
//           const char *licensePath = [licensePathNS UTF8String];
//           CPRCEN_engine *eng = CPRCEN_engine_load(voicePath, licensePath, NULL,NULL,NULL);
//     NSString *textNS = call.arguments[@"text"];
//       const char *test = [textNS UTF8String];
//     CPRCEN_channel_handle chan = CPRCEN_engine_open_default_channel(eng);
//     CPRC_abuf *abuf = CPRCEN_engine_channel_speak(eng, chan, test, strlen(test), 1);
//     CPTP_fixedbuf *riff = CPRC_riff_buffer(abuf);
//     NSData *soundData = [[NSData alloc] initWithBytes: (const void *)riff->_buffer length: riff->_size];
//     NSError *playerError = nil;
//     AVAudioPlayer *avPlayer =
//         [[AVAudioPlayer alloc] initWithData: soundData error: &playerError];
//     if (!avPlayer) {
//
//         printf(@"ERROR: could not play back audio, code");
//     } else {
//         [avPlayer setDelegate: self];
//         [avPlayer prepareToPlay];
//         [avPlayer play];
//         while([avPlayer isPlaying]) {
//             [NSThread sleepForTimeInterval:.01];
//         }
//     }
//     result(@"done");
//   } else {
//     result(FlutterMethodNotImplemented);
//   }
// }
// @end


//
//#import "PluginsPlugin.h"
//
//CPRCEN_engine *eng;
//
//@implementation PluginsPlugin
//+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  FlutterMethodChannel* channel = [FlutterMethodChannel
//      methodChannelWithName:@"plugins"
//            binaryMessenger:[registrar messenger]];
//  PluginsPlugin* instance = [[PluginsPlugin alloc] init];
//  [registrar addMethodCallDelegate:instance channel:channel];
//}
//
//- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//
//      if ([@"cereEngInit" isEqualToString:call.method]) {
//        NSString *voicePathNS = [[NSBundle mainBundle] pathForResource:@"tts" ofType:@"voice"];
//        NSString *licensePathNS = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"lic"];
//        const char *voicePath = [voicePathNS UTF8String];
//        const char *licensePath = [licensePathNS UTF8String];
//        eng = CPRCEN_engine_load(voicePath, licensePath, NULL,NULL,NULL);
//        result(@"done");
//      }
//
//
//      if ([@"cereSpeak" isEqualToString:call.method]) {
//    NSString *textNS = call.arguments[@"text"];
//      const char *text = [textNS UTF8String];
//
//
//          //
//          // Synthesis calls
//          //
//
//          // Open a channel - the engine is initialised, and the voice loaded,
//          // when the application is started.
//          CPRCEN_channel_handle chan = CPRCEN_engine_open_default_channel(eng);
//          // Synthesise to a CereProc audio buffer, see cerevoice_eng.h for
//          // details about the structure (some developers may wish to use the
//          // audio buffer directly).
//          CPRC_abuf *abuf = CPRCEN_engine_channel_speak(eng, chan, text, strlen(text), 1);
//          // Convert the audio buffer into a sequence of bytes with a RIFF header,
//          // this allows an audio player to be initialised from memory.  This
//          // is allocated memory, so the buffer needs cleaning up later.
//          CPTP_fixedbuf *riff = CPRC_riff_buffer(abuf);
//
//          //
//          // Audio playback
//          //
//
//          // Create an audio data object from our RIFF bytes
//          NSData *soundData = [[NSData alloc] initWithBytes: (const void *)riff->_buffer length: riff->_size];
//          NSError *playerError = nil;
//          // Create an audio player
//          AVAudioPlayer *avPlayer =
//              [[AVAudioPlayer alloc] initWithData: soundData
//                                            error: &playerError];
//          if (!avPlayer) {
//              // Check for player problems
//              NSInteger messageCode = [playerError code];
//              NSString *messageString = [playerError localizedDescription];
//              printf("ERROR: could not play back audio, code '%d' message '%s'\n", messageCode, [messageString UTF8String]);
//          } else {
//              // The delegate is used to clean up the player when it is finished,
//              // it can also be used to update buttons in a GUI etc.
//
//              // Initialize the player
//              [avPlayer prepareToPlay];
//              // Kick off playback - note that playback is performed in
//              // in a separate thread, so this function will return
//              // before playback is completed.
//              [avPlayer play];
//              // Wait for player to finish
//              while([avPlayer isPlaying]) {
//                  [NSThread sleepForTimeInterval:.01];
//              }
//          }
//
//          //
//          // Clean up
//          //
//          CPRCEN_engine_channel_close(eng, chan);
//          CPTP_fixedbuf_delete(riff);
//
//
//
//    result(@"done");
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
//}
//@end
