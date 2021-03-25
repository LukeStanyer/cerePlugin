// Copyright (c) 2011-2019 CereProc Ltd.
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <AVFoundation/AVFoundation.h>
#import "cerevoice_eng.h"
#import "cerevoice_eng_simp.h"


@interface Wrapped_CPRCEN_engine : NSObject <NSCopying>
@property CPRCEN_engine* val;
- (void) setObj:(CPRCEN_engine*)obj;
@end
@interface Wrapped_CPRC_abuf : NSObject <NSCopying>
@property CPRC_abuf* val;
- (void) setObj:(CPRC_abuf*)obj;
@end
@interface Wrapped_CPRC_abuf_trans : NSObject <NSCopying>
@property CPRC_abuf_trans* val;
- (void) setObj:(CPRC_abuf_trans*)obj;
@end
@interface Wrapped_CPTP_fixedbuf : NSObject <NSCopying>
@property CPTP_fixedbuf* val;
- (void) setObj:(CPTP_fixedbuf*)obj;
@end
@interface Wrapped_CPRCEN_wav : NSObject <NSCopying>
@property CPRCEN_wav* val;
- (void) setObj:(CPRCEN_wav*)obj;
@end

@interface WrappedObjects : NSObject
@property NSMutableDictionary* objects;
- (NSString*) addObj:(NSObject<NSCopying>*)val;
- (void) addObjKey:(NSString*)key Value:(NSObject*)val;
- (NSObject*) getObj:(NSString*)key;
- (void) delObjByKey:(NSString*)key;
- (void) delObj:(NSObject<NSCopying>*)val;
@end

@interface CerevoiceEng : RCTEventEmitter <RCTBridgeModule>
@property NSArray<NSString*>* eventNames;
@property NSMutableDictionary* abufQueue;

-(NSArray<NSString*>*)supportedEvents;
-(void)emitEvent:(NSString*)name body:(id)body;
+ (NSString*) ST_CPRCEN_engine_new;
+ (NSString*) ST_CPRCEN_engine_load:(NSString*)voicefNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS certkey:(NSString*)certkeyNS;
+ (NSString*) ST_CPRCEN_engine_load_config:(NSString*)voicefNS voice_configf:(NSString*)voice_configfNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS certkey:(NSString*)certkeyNS;
+ (int) ST_CPRCEN_engine_load_voice:(NSString*)engKey voicef:(NSString*)voicefNS configf:(NSString*)configfNS load_type:(nonnull NSNumber*)load_typeNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS cert_key:(NSString*)cert_keyNS;
+ (int) ST_CPRCEN_engine_load_voice_licensestr:(NSString*)engKey license_text:(NSString*)license_textNS signature:(NSString*)signatureNS configf:(NSString*)configfNS voicef:(NSString*)voicefNS load_type:(nonnull NSNumber*)load_typeNS;
+ (int) ST_CPRCEN_engine_unload_voice:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS;
+ (void) ST_CPRCEN_engine_delete:(NSString*)engKey;
+ (int) ST_CPRCEN_engine_load_user_lexicon:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS fname:(NSString*)fnameNS;
+ (int) ST_CPRCEN_engine_load_user_abbreviations:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS fname:(NSString*)fnameNS;
+ (int) ST_CPRCEN_engine_load_channel_lexicon:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS lname:(NSString*)lnameNS;
+ (int) ST_CPRCEN_engine_load_channel_pls:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS lname:(NSString*)lnameNS;
+ (int) ST_CPRCEN_engine_load_channel_abbreviation:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS aname:(NSString*)anameNS;
+ (int) ST_CPRCEN_engine_load_channel_pbreak:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS;
+ (int) ST_CPRCEN_engine_get_voice_count:(NSString*)engKey;
+ (NSString*) ST_CPRCEN_engine_get_voice_info:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS key:(NSString*)keyNS;
+ (NSString*) ST_CPRCEN_engine_get_voice_file_info:(NSString*)fnameNS key:(NSString*)keyNS;
+ (int) ST_CPRCEN_engine_open_channel:(NSString*)engKey iso_language_code:(NSString*)iso_language_codeNS iso_region_code:(NSString*)iso_region_codeNS voice_name:(NSString*)voice_nameNS srate:(NSString*)srateNS;
+ (int) ST_CPRCEN_engine_open_default_channel:(NSString*)engKey;
+ (int) ST_CPRCEN_engine_channel_reset:(NSString*)engKey chan:(nonnull NSNumber*)chanNS;
+ (int) ST_CPRCEN_engine_channel_close:(NSString*)engKey chan:(nonnull NSNumber*)chanNS;
+ (int) ST_CPRCEN_engine_clear_callback:(NSString*)engKey chan:(nonnull NSNumber*)chanNS;
+ (NSString*) ST_CPRCEN_engine_channel_speak:(NSString*)engKey chan:(nonnull NSNumber*)chanNS text:(NSString*)textNS textlen:(nonnull NSNumber*)textlenNS flush:(nonnull NSNumber*)flushNS;
+ (NSString*) ST_CPRCEN_engine_channel_interrupt:(NSString*)engKey chan:(nonnull NSNumber*)chanNS spurtxml:(NSString*)spurtxmlNS xmllen:(nonnull NSNumber*)xmllenNS earliest_time:(nonnull NSNumber*)earliest_timeNS btype:(nonnull NSNumber*)btypeNS itype:(nonnull NSNumber*)itypeNS;
+ (NSString*) ST_CPRCEN_channel_get_voice_info:(NSString*)engKey chan:(nonnull NSNumber*)chanNS key:(NSString*)keyNS;
+ (int) ST_CPRCEN_engine_channel_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS;
+ (int) ST_CPRCEN_engine_channel_append_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS;
+ (int) ST_CPRCEN_engine_channel_force_append_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS;
+ (int) ST_CPRCEN_engine_channel_no_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS;
+ (int) ST_CPRCEN_channel_synth_type_usel:(NSString*)engKey chan:(nonnull NSNumber*)chanNS;
+ (int) ST_CPRCEN_channel_set_phone_min_max:(NSString*)engKey chan:(nonnull NSNumber*)chanNS min:(nonnull NSNumber*)minNS max:(nonnull NSNumber*)maxNS;
+ (int) ST_CPRCEN_channel_set_pipe_length:(NSString*)engKey chan:(nonnull NSNumber*)chanNS pipelen:(nonnull NSNumber*)pipelenNS;
+ (NSString*) ST_CPRC_abuf_get_trans:(NSString*)abKey i:(nonnull NSNumber*)iNS;
+ (int) ST_CPRC_abuf_trans_sz:(NSString*)abKey;
+ (NSString*) ST_CPRC_abuf_trans_name:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_type:(NSString*)tKey;
+ (float) ST_CPRC_abuf_trans_start:(NSString*)tKey;
+ (float) ST_CPRC_abuf_trans_end:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_start_sample:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_end_sample:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_phone_stress:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_sapi_viseme:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_disney_viseme:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_sapi_phoneid:(NSString*)tKey;
+ (int) ST_CPRC_abuf_trans_mac_phoneid:(NSString*)tKey;
+ (int) ST_CPRC_abuf_wav_sz:(NSString*)abKey;
+ (short) ST_CPRC_abuf_wav:(NSString*)abKey i:(nonnull NSNumber*)iNS;
+ (int) ST_CPRC_abuf_wav_mk:(NSString*)abKey;
+ (int) ST_CPRC_abuf_wav_done:(NSString*)abKey;
+ (int) ST_CPRC_abuf_added_wav_sz:(NSString*)abKey;
+ (int) ST_CPRC_abuf_trans_mk:(NSString*)abKey;
+ (int) ST_CPRC_abuf_trans_done:(NSString*)abKey;
+ (int) ST_CPRC_abuf_wav_srate:(NSString*)abKey;
+ (int) ST_CPRC_riff_save:(NSString*)wavKey fname:(NSString*)fnameNS;
+ (int) ST_CPRC_riff_append:(NSString*)wavKey fname:(NSString*)fnameNS;
+ (int) ST_CPRC_riff_save_trans:(NSString*)wavKey fname:(NSString*)fnameNS;
+ (NSString*) ST_CPRC_riff_buffer:(NSString*)wavKey;
+ (void) ST_CPTP_fixedbuf_delete:(NSString*)fbKey;
+ (NSString*) ST_CPRC_abuf_copy:(NSString*)abKey;
+ (NSString*) ST_CPRC_abuf_extract:(NSString*)abKey offset:(nonnull NSNumber*)offsetNS sz:(nonnull NSNumber*)szNS;
+ (void) ST_CPRC_abuf_delete:(NSString*)abKey;
+ (NSString*) ST_CPRC_abuf_append:(NSString*)ab_outKey ab_in:(NSString*)ab_inKey;
+ (int) ST_CPRCEN_major_version;
+ (int) ST_CPRCEN_minor_version;
+ (int) ST_CPRCEN_revision_number;
+ (NSString*) ST_CPRCEN_engine_speak:(NSString*)engKey text:(NSString*)textNS;
+ (int) ST_CPRCEN_engine_speak_to_file:(NSString*)engKey text:(NSString*)textNS fname:(NSString*)fnameNS;
+ (int) ST_CPRCEN_engine_clear:(NSString*)engKey;
@end

// PRE-WRITTEN CLASSES START
@interface UserData : NSObject
@property NSString* callbackEvent;
@property CerevoiceEng* bridgeModule;
@end

// PRE-WRITTEN CLASSES END