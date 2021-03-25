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

#include <stdlib.h>
#include <limits.h>
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <AVFoundation/AVFoundation.h>
#import "CerevoiceEng.h"

// PRE-WRITTEN CLASSES START
NSMutableDictionary* UserDataDict;
WrappedObjects* wrappedObjects;
void wrap_CPRCEN_engine_callback_call(CPRC_abuf* abuf, void* userdata) {
    NSString* ud_addr = [NSString stringWithFormat:@"%p", userdata];
    UserData* ud = [UserDataDict valueForKey:ud_addr];
    NSString* callbackEvent = ud.callbackEvent;
    CerevoiceEng* module = ud.bridgeModule;

    Wrapped_CPRC_abuf* wrap_abuf = [[Wrapped_CPRC_abuf alloc] init];
    wrap_abuf.val = CPRC_abuf_copy(abuf);
    NSString *address = [NSString stringWithFormat:@"%p", wrap_abuf.val];
    [wrappedObjects addObjKey:address Value:wrap_abuf];

    NSString *callbackID = [module.abufQueue valueForKey:[NSString stringWithFormat:@"%@_key",callbackEvent]];

    [(NSMutableArray*)[module.abufQueue valueForKey:callbackEvent] addObject:wrap_abuf];
    if ([(NSMutableArray*)[module.abufQueue valueForKey:callbackEvent] count] == 1) {
        [module emitEvent:callbackEvent body:@{@"abuf": address, @"cbid":callbackID}];
    }
}

@implementation UserData
@end

// PRE-WRITTEN CLASSES END

@implementation Wrapped_CPRCEN_engine

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setObj:(CPRCEN_engine*)obj {
    if (self) {
        _val = obj;
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setObj:self.val];
    }
    return copy;
}

@end
@implementation Wrapped_CPRC_abuf

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setObj:(CPRC_abuf*)obj {
    if (self) {
        _val = obj;
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setObj:self.val];
    }
    return copy;
}

@end
@implementation Wrapped_CPRC_abuf_trans

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setObj:(CPRC_abuf_trans*)obj {
    if (self) {
        _val = obj;
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setObj:self.val];
    }
    return copy;
}

@end
@implementation Wrapped_CPTP_fixedbuf

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setObj:(CPTP_fixedbuf*)obj {
    if (self) {
        _val = obj;
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setObj:self.val];
    }
    return copy;
}

@end
@implementation Wrapped_CPRCEN_wav

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setObj:(CPRCEN_wav*)obj {
    if (self) {
        _val = obj;
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setObj:self.val];
    }
    return copy;
}

@end@implementation WrappedObjects

- (instancetype) init {
    self = [super init];
    _objects = @{}.mutableCopy;
    return self;
}

- (NSString*) addObj:(NSObject<NSCopying>*)val {
    NSString *key = [NSString stringWithFormat:@"%p", val];
    [_objects setObject:val forKey:key];
    return key;
}

- (void) addObjKey:(NSString*)key Value:(NSObject<NSCopying>*)val {
    [_objects setObject:val forKey:key];
}

- (NSObject<NSCopying>*) getObj:(NSString*)key {
    NSObject<NSCopying>* obj = (NSObject<NSCopying>*)[_objects objectForKey:key];
    return obj;
}

- (void) delObjByKey:(NSString*)key {
    [_objects removeObjectForKey:key];
}
- (void) delObj:(NSObject<NSCopying>*)val {
    NSString *key = [NSString stringWithFormat:@"%p", val];
    [_objects removeObjectForKey:key];
}

@end

@implementation CerevoiceEng

- (instancetype) init {
    self = [super init];
    wrappedObjects = [[WrappedObjects alloc] init];
    return self;
}

+(BOOL)requiresMainQueueSetup {
    return NO;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// To add an event, add the event name to the _eventNames array
-(NSArray<NSString*>*)supportedEvents{
    return _eventNames;
}
-(void)emitEvent:(NSString*)name body:(id)body {
    [self sendEventWithName:name body:body];
}

// PRE-WRITTEN FUNCTIONS START
RCT_EXPORT_METHOD(null:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString* nullStr = [NSString stringWithFormat:@"%p",nil];
    resolve(nullStr);
}

RCT_EXPORT_METHOD(CPRC_abuf_wav_encoded:(NSString *)abufKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_abuf = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abufKey];
    CPRC_abuf* abuf = wrap_abuf.val;

    int sz = CPRC_abuf_wav_sz(abuf);
    char bytes[sz*2];
    int element;
    int tmp = 0;
    for (int i = 0; i < sz; i++) {
        element = CPRC_abuf_wav(abuf, i);
        tmp = (int)((element - SHRT_MIN)%(CHAR_MAX-CHAR_MIN));
        bytes[2*i] = (char)((element - SHRT_MIN - tmp) / (CHAR_MAX-CHAR_MIN)+CHAR_MIN);
        bytes[2*i+1] = (char)(tmp + CHAR_MIN);
    }
    NSData *data = [NSData dataWithBytes:bytes length:sz*2];
    NSString* dataStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    resolve(dataStr);
}

RCT_EXPORT_METHOD(CPRCEN_engine_callback_end:(NSString *)callbackEvent) {
    [(NSMutableArray*)[_abufQueue valueForKey:callbackEvent] removeObjectAtIndex:0];
    if ([(NSMutableArray*)[_abufQueue valueForKey:callbackEvent] count] > 0) {
        Wrapped_CPRC_abuf* currAbuf= [(NSMutableArray*)[_abufQueue valueForKey:callbackEvent] firstObject];
        NSString *address = [NSString stringWithFormat:@"%p", currAbuf.val];
        NSString *callbackID = [_abufQueue valueForKey:[NSString stringWithFormat:@"%@_key",callbackEvent]];
        [self emitEvent:callbackEvent body:@{@"abuf": address, @"cbid":callbackID}];
    }
}

RCT_EXPORT_METHOD(CPRCEN_engine_set_callback_wrapped:(NSString *)engKey
                  chan:(nonnull NSNumber*)chan
                  cbid:(NSString *)cbid
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;

    UserData* userdata = [[UserData alloc] init];
    userdata.callbackEvent = [NSString stringWithFormat:@"callback%d", arc4random_uniform(100)];
    userdata.bridgeModule = self;
    if (!UserDataDict)
        UserDataDict = @{}.mutableCopy;
    NSString *ud_addr = [NSString stringWithFormat:@"%p", userdata];
    [UserDataDict setObject:userdata forKey:ud_addr];

    if (!_eventNames)
        _eventNames = @[];
    _eventNames = [_eventNames arrayByAddingObject:userdata.callbackEvent];

    if (!_abufQueue)
        _abufQueue = @{}.mutableCopy;
    if (![_abufQueue objectForKey:userdata.callbackEvent])
        [_abufQueue setObject:@[].mutableCopy forKey:userdata.callbackEvent];
    [_abufQueue setObject:cbid forKey:[NSString stringWithFormat:@"%@_key", userdata.callbackEvent]];

    int result = CPRCEN_engine_set_callback(eng, [chan intValue], (__bridge void*)userdata, wrap_CPRCEN_engine_callback_call);
    if (result)
        resolve(userdata.callbackEvent);
    else
        reject(@"Failed", @"Could not set callback", nil);
}
// PRE-WRITTEN FUNCTIONS END

+ (NSString*) ST_CPRCEN_engine_new {
    CPRCEN_engine * res = CPRCEN_engine_new();
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_engine* wrap_res = [[Wrapped_CPRCEN_engine alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (NSString*) ST_CPRCEN_engine_load:(NSString*)voicefNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS certkey:(NSString*)certkeyNS {
    char * voicef = [voicefNS UTF8String];
    char * licensef = [licensefNS UTF8String];
    char * root_certf = [root_certfNS UTF8String];
    char * certf = [certfNS UTF8String];
    char * certkey = [certkeyNS UTF8String];
    CPRCEN_engine * res = CPRCEN_engine_load(voicef, licensef, root_certf, certf, certkey);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_engine* wrap_res = [[Wrapped_CPRCEN_engine alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (NSString*) ST_CPRCEN_engine_load_config:(NSString*)voicefNS voice_configf:(NSString*)voice_configfNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS certkey:(NSString*)certkeyNS {
    char * voicef = [voicefNS UTF8String];
    char * voice_configf = [voice_configfNS UTF8String];
    char * licensef = [licensefNS UTF8String];
    char * root_certf = [root_certfNS UTF8String];
    char * certf = [certfNS UTF8String];
    char * certkey = [certkeyNS UTF8String];
    CPRCEN_engine * res = CPRCEN_engine_load_config(voicef, voice_configf, licensef, root_certf, certf, certkey);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_engine* wrap_res = [[Wrapped_CPRCEN_engine alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (int) ST_CPRCEN_engine_load_voice:(NSString*)engKey voicef:(NSString*)voicefNS configf:(NSString*)configfNS load_type:(nonnull NSNumber*)load_typeNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS cert_key:(NSString*)cert_keyNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * voicef = [voicefNS UTF8String];
    char * configf = [configfNS UTF8String];
    int load_type = [load_typeNS intValue];
    char * licensef = [licensefNS UTF8String];
    char * root_certf = [root_certfNS UTF8String];
    char * certf = [certfNS UTF8String];
    char * cert_key = [cert_keyNS UTF8String];
    int res = CPRCEN_engine_load_voice(eng, voicef, configf, load_type, licensef, root_certf, certf, cert_key);
    return res;
}
+ (int) ST_CPRCEN_engine_load_voice_licensestr:(NSString*)engKey license_text:(NSString*)license_textNS signature:(NSString*)signatureNS configf:(NSString*)configfNS voicef:(NSString*)voicefNS load_type:(nonnull NSNumber*)load_typeNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * license_text = [license_textNS UTF8String];
    char * signature = [signatureNS UTF8String];
    char * configf = [configfNS UTF8String];
    char * voicef = [voicefNS UTF8String];
    int load_type = [load_typeNS intValue];
    int res = CPRCEN_engine_load_voice_licensestr(eng, license_text, signature, configf, voicef, load_type);
    return res;
}
+ (int) ST_CPRCEN_engine_unload_voice:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    int res = CPRCEN_engine_unload_voice(eng, voice_index);
    return res;
}
+ (void) ST_CPRCEN_engine_delete:(NSString*)engKey {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    CPRCEN_engine_delete(eng);
}
+ (int) ST_CPRCEN_engine_load_user_lexicon:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS fname:(NSString*)fnameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_load_user_lexicon(eng, voice_index, fname);
    return res;
}
+ (int) ST_CPRCEN_engine_load_user_abbreviations:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS fname:(NSString*)fnameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_load_user_abbreviations(eng, voice_index, fname);
    return res;
}
+ (int) ST_CPRCEN_engine_load_channel_lexicon:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS lname:(NSString*)lnameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    char * lname = [lnameNS UTF8String];
    int res = CPRCEN_engine_load_channel_lexicon(eng, chan, fname, lname);
    return res;
}
+ (int) ST_CPRCEN_engine_load_channel_pls:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS lname:(NSString*)lnameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    char * lname = [lnameNS UTF8String];
    int res = CPRCEN_engine_load_channel_pls(eng, chan, fname, lname);
    return res;
}
+ (int) ST_CPRCEN_engine_load_channel_abbreviation:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS aname:(NSString*)anameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    char * aname = [anameNS UTF8String];
    int res = CPRCEN_engine_load_channel_abbreviation(eng, chan, fname, aname);
    return res;
}
+ (int) ST_CPRCEN_engine_load_channel_pbreak:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_load_channel_pbreak(eng, chan, fname);
    return res;
}
+ (int) ST_CPRCEN_engine_get_voice_count:(NSString*)engKey {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int res = CPRCEN_engine_get_voice_count(eng);
    return res;
}
+ (NSString*) ST_CPRCEN_engine_get_voice_info:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS key:(NSString*)keyNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    char * key = [keyNS UTF8String];
    char * res = CPRCEN_engine_get_voice_info(eng, voice_index, key);
    return [NSString stringWithUTF8String:res];
}
+ (NSString*) ST_CPRCEN_engine_get_voice_file_info:(NSString*)fnameNS key:(NSString*)keyNS {
    char * fname = [fnameNS UTF8String];
    char * key = [keyNS UTF8String];
    char * res = CPRCEN_engine_get_voice_file_info(fname, key);
    return [NSString stringWithUTF8String:res];
}
+ (int) ST_CPRCEN_engine_open_channel:(NSString*)engKey iso_language_code:(NSString*)iso_language_codeNS iso_region_code:(NSString*)iso_region_codeNS voice_name:(NSString*)voice_nameNS srate:(NSString*)srateNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * iso_language_code = [iso_language_codeNS UTF8String];
    char * iso_region_code = [iso_region_codeNS UTF8String];
    char * voice_name = [voice_nameNS UTF8String];
    char * srate = [srateNS UTF8String];
    int res = CPRCEN_engine_open_channel(eng, iso_language_code, iso_region_code, voice_name, srate);
    return res;
}
+ (int) ST_CPRCEN_engine_open_default_channel:(NSString*)engKey {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int res = CPRCEN_engine_open_default_channel(eng);
    return res;
}
+ (int) ST_CPRCEN_engine_channel_reset:(NSString*)engKey chan:(nonnull NSNumber*)chanNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_channel_reset(eng, chan);
    return res;
}
+ (int) ST_CPRCEN_engine_channel_close:(NSString*)engKey chan:(nonnull NSNumber*)chanNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_channel_close(eng, chan);
    return res;
}
+ (int) ST_CPRCEN_engine_clear_callback:(NSString*)engKey chan:(nonnull NSNumber*)chanNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_clear_callback(eng, chan);
    return res;
}
+ (NSString*) ST_CPRCEN_engine_channel_speak:(NSString*)engKey chan:(nonnull NSNumber*)chanNS text:(NSString*)textNS textlen:(nonnull NSNumber*)textlenNS flush:(nonnull NSNumber*)flushNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * text = [textNS UTF8String];
    int textlen = [textlenNS intValue];
    int flush = [flushNS intValue];
    CPRC_abuf * res = CPRCEN_engine_channel_speak(eng, chan, text, textlen, flush);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (NSString*) ST_CPRCEN_engine_channel_interrupt:(NSString*)engKey chan:(nonnull NSNumber*)chanNS spurtxml:(NSString*)spurtxmlNS xmllen:(nonnull NSNumber*)xmllenNS earliest_time:(nonnull NSNumber*)earliest_timeNS btype:(nonnull NSNumber*)btypeNS itype:(nonnull NSNumber*)itypeNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * spurtxml = [spurtxmlNS UTF8String];
    int xmllen = [xmllenNS intValue];
    float earliest_time = [earliest_timeNS floatValue];
    int btype = [btypeNS intValue];
    int itype = [itypeNS intValue];
    CPRC_abuf * res = CPRCEN_engine_channel_interrupt(eng, chan, spurtxml, xmllen, earliest_time, btype, itype);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (NSString*) ST_CPRCEN_channel_get_voice_info:(NSString*)engKey chan:(nonnull NSNumber*)chanNS key:(NSString*)keyNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * key = [keyNS UTF8String];
    char * res = CPRCEN_channel_get_voice_info(eng, chan, key);
    return [NSString stringWithUTF8String:res];
}
+ (int) ST_CPRCEN_engine_channel_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int format = [formatNS intValue];
    int res = CPRCEN_engine_channel_to_file(eng, chan, fname, format);
    return res;
}
+ (int) ST_CPRCEN_engine_channel_append_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int format = [formatNS intValue];
    int res = CPRCEN_engine_channel_append_to_file(eng, chan, fname, format);
    return res;
}
+ (int) ST_CPRCEN_engine_channel_force_append_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int format = [formatNS intValue];
    int res = CPRCEN_engine_channel_force_append_to_file(eng, chan, fname, format);
    return res;
}
+ (int) ST_CPRCEN_engine_channel_no_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_channel_no_file(eng, chan);
    return res;
}
+ (int) ST_CPRCEN_channel_synth_type_usel:(NSString*)engKey chan:(nonnull NSNumber*)chanNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_channel_synth_type_usel(eng, chan);
    return res;
}
+ (int) ST_CPRCEN_channel_set_phone_min_max:(NSString*)engKey chan:(nonnull NSNumber*)chanNS min:(nonnull NSNumber*)minNS max:(nonnull NSNumber*)maxNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int min = [minNS intValue];
    int max = [maxNS intValue];
    int res = CPRCEN_channel_set_phone_min_max(eng, chan, min, max);
    return res;
}
+ (int) ST_CPRCEN_channel_set_pipe_length:(NSString*)engKey chan:(nonnull NSNumber*)chanNS pipelen:(nonnull NSNumber*)pipelenNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int pipelen = [pipelenNS intValue];
    int res = CPRCEN_channel_set_pipe_length(eng, chan, pipelen);
    return res;
}
+ (NSString*) ST_CPRC_abuf_get_trans:(NSString*)abKey i:(nonnull NSNumber*)iNS {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int i = [iNS intValue];
    CPRC_abuf_trans * res = CPRC_abuf_get_trans(ab, i);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf_trans* wrap_res = [[Wrapped_CPRC_abuf_trans alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (int) ST_CPRC_abuf_trans_sz:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_trans_sz(ab);
    return res;
}
+ (NSString*) ST_CPRC_abuf_trans_name:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    char * res = CPRC_abuf_trans_name(t);
    return [NSString stringWithUTF8String:res];
}
+ (int) ST_CPRC_abuf_trans_type:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    enum CPRC_ABUF_TRANS res = CPRC_abuf_trans_type(t);
    return (int)res;
}
+ (float) ST_CPRC_abuf_trans_start:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    float res = CPRC_abuf_trans_start(t);
    return res;
}
+ (float) ST_CPRC_abuf_trans_end:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    float res = CPRC_abuf_trans_end(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_start_sample:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_start_sample(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_end_sample:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_end_sample(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_phone_stress:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_phone_stress(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_sapi_viseme:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_sapi_viseme(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_disney_viseme:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_disney_viseme(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_sapi_phoneid:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_sapi_phoneid(t);
    return res;
}
+ (int) ST_CPRC_abuf_trans_mac_phoneid:(NSString*)tKey {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_mac_phoneid(t);
    return res;
}
+ (int) ST_CPRC_abuf_wav_sz:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_sz(ab);
    return res;
}
+ (short) ST_CPRC_abuf_wav:(NSString*)abKey i:(nonnull NSNumber*)iNS {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int i = [iNS intValue];
    short res = CPRC_abuf_wav(ab, i);
    return res;
}
+ (int) ST_CPRC_abuf_wav_mk:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_mk(ab);
    return res;
}
+ (int) ST_CPRC_abuf_wav_done:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_done(ab);
    return res;
}
+ (int) ST_CPRC_abuf_added_wav_sz:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_added_wav_sz(ab);
    return res;
}
+ (int) ST_CPRC_abuf_trans_mk:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_trans_mk(ab);
    return res;
}
+ (int) ST_CPRC_abuf_trans_done:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_trans_done(ab);
    return res;
}
+ (int) ST_CPRC_abuf_wav_srate:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_srate(ab);
    return res;
}
+ (int) ST_CPRC_riff_save:(NSString*)wavKey fname:(NSString*)fnameNS {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    char * fname = [fnameNS UTF8String];
    int res = CPRC_riff_save(wav, fname);
    return res;
}
+ (int) ST_CPRC_riff_append:(NSString*)wavKey fname:(NSString*)fnameNS {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    char * fname = [fnameNS UTF8String];
    int res = CPRC_riff_append(wav, fname);
    return res;
}
+ (int) ST_CPRC_riff_save_trans:(NSString*)wavKey fname:(NSString*)fnameNS {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    char * fname = [fnameNS UTF8String];
    int res = CPRC_riff_save_trans(wav, fname);
    return res;
}
+ (NSString*) ST_CPRC_riff_buffer:(NSString*)wavKey {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    CPTP_fixedbuf * res = CPRC_riff_buffer(wav);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPTP_fixedbuf* wrap_res = [[Wrapped_CPTP_fixedbuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (void) ST_CPTP_fixedbuf_delete:(NSString*)fbKey {
    Wrapped_CPTP_fixedbuf* wrap_fb = (Wrapped_CPTP_fixedbuf*) [wrappedObjects getObj:fbKey];
    CPTP_fixedbuf* fb = wrap_fb.val;
    CPTP_fixedbuf_delete(fb);
}
+ (NSString*) ST_CPRC_abuf_copy:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    CPRC_abuf * res = CPRC_abuf_copy(ab);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (NSString*) ST_CPRC_abuf_extract:(NSString*)abKey offset:(nonnull NSNumber*)offsetNS sz:(nonnull NSNumber*)szNS {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int offset = [offsetNS intValue];
    int sz = [szNS intValue];
    CPRC_abuf * res = CPRC_abuf_extract(ab, offset, sz);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (void) ST_CPRC_abuf_delete:(NSString*)abKey {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    CPRC_abuf_delete(ab);
}
+ (NSString*) ST_CPRC_abuf_append:(NSString*)ab_outKey ab_in:(NSString*)ab_inKey {
    Wrapped_CPRC_abuf* wrap_ab_out = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:ab_outKey];
    CPRC_abuf* ab_out = wrap_ab_out.val;
    Wrapped_CPRC_abuf* wrap_ab_in = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:ab_inKey];
    CPRC_abuf* ab_in = wrap_ab_in.val;
    CPRC_abuf * res = CPRC_abuf_append(ab_out, ab_in);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (int) ST_CPRCEN_major_version {
    int res = CPRCEN_major_version();
    return res;
}
+ (int) ST_CPRCEN_minor_version {
    int res = CPRCEN_minor_version();
    return res;
}
+ (int) ST_CPRCEN_revision_number {
    int res = CPRCEN_revision_number();
    return res;
}
+ (NSString*) ST_CPRCEN_engine_speak:(NSString*)engKey text:(NSString*)textNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * text = [textNS UTF8String];
    CPRCEN_wav * res = CPRCEN_engine_speak(eng, text);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_wav* wrap_res = [[Wrapped_CPRCEN_wav alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    return result;
}
+ (int) ST_CPRCEN_engine_speak_to_file:(NSString*)engKey text:(NSString*)textNS fname:(NSString*)fnameNS {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * text = [textNS UTF8String];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_speak_to_file(eng, text, fname);
    return res;
}
+ (int) ST_CPRCEN_engine_clear:(NSString*)engKey {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int res = CPRCEN_engine_clear(eng);
    return res;
}

RCT_EXPORT_METHOD(CPRCEN_engine_new:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    CPRCEN_engine * res = CPRCEN_engine_new();
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_engine* wrap_res = [[Wrapped_CPRCEN_engine alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load:(NSString*)voicefNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS certkey:(NSString*)certkeyNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    char * voicef = [voicefNS UTF8String];
    char * licensef = [licensefNS UTF8String];
    char * root_certf = [root_certfNS UTF8String];
    char * certf = [certfNS UTF8String];
    char * certkey = [certkeyNS UTF8String];
    CPRCEN_engine * res = CPRCEN_engine_load(voicef, licensef, root_certf, certf, certkey);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_engine* wrap_res = [[Wrapped_CPRCEN_engine alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_config:(NSString*)voicefNS voice_configf:(NSString*)voice_configfNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS certkey:(NSString*)certkeyNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    char * voicef = [voicefNS UTF8String];
    char * voice_configf = [voice_configfNS UTF8String];
    char * licensef = [licensefNS UTF8String];
    char * root_certf = [root_certfNS UTF8String];
    char * certf = [certfNS UTF8String];
    char * certkey = [certkeyNS UTF8String];
    CPRCEN_engine * res = CPRCEN_engine_load_config(voicef, voice_configf, licensef, root_certf, certf, certkey);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_engine* wrap_res = [[Wrapped_CPRCEN_engine alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_voice:(NSString*)engKey voicef:(NSString*)voicefNS configf:(NSString*)configfNS load_type:(nonnull NSNumber*)load_typeNS licensef:(NSString*)licensefNS root_certf:(NSString*)root_certfNS certf:(NSString*)certfNS cert_key:(NSString*)cert_keyNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * voicef = [voicefNS UTF8String];
    char * configf = [configfNS UTF8String];
    int load_type = [load_typeNS intValue];
    char * licensef = [licensefNS UTF8String];
    char * root_certf = [root_certfNS UTF8String];
    char * certf = [certfNS UTF8String];
    char * cert_key = [cert_keyNS UTF8String];
    int res = CPRCEN_engine_load_voice(eng, voicef, configf, load_type, licensef, root_certf, certf, cert_key);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_voice_licensestr:(NSString*)engKey license_text:(NSString*)license_textNS signature:(NSString*)signatureNS configf:(NSString*)configfNS voicef:(NSString*)voicefNS load_type:(nonnull NSNumber*)load_typeNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * license_text = [license_textNS UTF8String];
    char * signature = [signatureNS UTF8String];
    char * configf = [configfNS UTF8String];
    char * voicef = [voicefNS UTF8String];
    int load_type = [load_typeNS intValue];
    int res = CPRCEN_engine_load_voice_licensestr(eng, license_text, signature, configf, voicef, load_type);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_unload_voice:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    int res = CPRCEN_engine_unload_voice(eng, voice_index);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_delete:(NSString*)engKey) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    CPRCEN_engine_delete(eng);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_user_lexicon:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_load_user_lexicon(eng, voice_index, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_user_abbreviations:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_load_user_abbreviations(eng, voice_index, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_channel_lexicon:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS lname:(NSString*)lnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    char * lname = [lnameNS UTF8String];
    int res = CPRCEN_engine_load_channel_lexicon(eng, chan, fname, lname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_channel_pls:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS lname:(NSString*)lnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    char * lname = [lnameNS UTF8String];
    int res = CPRCEN_engine_load_channel_pls(eng, chan, fname, lname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_channel_abbreviation:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS aname:(NSString*)anameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    char * aname = [anameNS UTF8String];
    int res = CPRCEN_engine_load_channel_abbreviation(eng, chan, fname, aname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_load_channel_pbreak:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_load_channel_pbreak(eng, chan, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_get_voice_count:(NSString*)engKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int res = CPRCEN_engine_get_voice_count(eng);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_get_voice_info:(NSString*)engKey voice_index:(nonnull NSNumber*)voice_indexNS key:(NSString*)keyNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int voice_index = [voice_indexNS intValue];
    char * key = [keyNS UTF8String];
    char * res = CPRCEN_engine_get_voice_info(eng, voice_index, key);
    NSString* result = [NSString stringWithUTF8String:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_get_voice_file_info:(NSString*)fnameNS key:(NSString*)keyNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    char * fname = [fnameNS UTF8String];
    char * key = [keyNS UTF8String];
    char * res = CPRCEN_engine_get_voice_file_info(fname, key);
    NSString* result = [NSString stringWithUTF8String:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_open_channel:(NSString*)engKey iso_language_code:(NSString*)iso_language_codeNS iso_region_code:(NSString*)iso_region_codeNS voice_name:(NSString*)voice_nameNS srate:(NSString*)srateNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * iso_language_code = [iso_language_codeNS UTF8String];
    char * iso_region_code = [iso_region_codeNS UTF8String];
    char * voice_name = [voice_nameNS UTF8String];
    char * srate = [srateNS UTF8String];
    int res = CPRCEN_engine_open_channel(eng, iso_language_code, iso_region_code, voice_name, srate);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_open_default_channel:(NSString*)engKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int res = CPRCEN_engine_open_default_channel(eng);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_reset:(NSString*)engKey chan:(nonnull NSNumber*)chanNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_channel_reset(eng, chan);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_close:(NSString*)engKey chan:(nonnull NSNumber*)chanNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_channel_close(eng, chan);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_clear_callback:(NSString*)engKey chan:(nonnull NSNumber*)chanNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_clear_callback(eng, chan);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_speak:(NSString*)engKey chan:(nonnull NSNumber*)chanNS text:(NSString*)textNS textlen:(nonnull NSNumber*)textlenNS flush:(nonnull NSNumber*)flushNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * text = [textNS UTF8String];
    int textlen = [textlenNS intValue];
    int flush = [flushNS intValue];
    CPRC_abuf * res = CPRCEN_engine_channel_speak(eng, chan, text, textlen, flush);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_interrupt:(NSString*)engKey chan:(nonnull NSNumber*)chanNS spurtxml:(NSString*)spurtxmlNS xmllen:(nonnull NSNumber*)xmllenNS earliest_time:(nonnull NSNumber*)earliest_timeNS btype:(nonnull NSNumber*)btypeNS itype:(nonnull NSNumber*)itypeNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * spurtxml = [spurtxmlNS UTF8String];
    int xmllen = [xmllenNS intValue];
    float earliest_time = [earliest_timeNS floatValue];
    int btype = [btypeNS intValue];
    int itype = [itypeNS intValue];
    CPRC_abuf * res = CPRCEN_engine_channel_interrupt(eng, chan, spurtxml, xmllen, earliest_time, btype, itype);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_channel_get_voice_info:(NSString*)engKey chan:(nonnull NSNumber*)chanNS key:(NSString*)keyNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * key = [keyNS UTF8String];
    char * res = CPRCEN_channel_get_voice_info(eng, chan, key);
    NSString* result = [NSString stringWithUTF8String:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int format = [formatNS intValue];
    int res = CPRCEN_engine_channel_to_file(eng, chan, fname, format);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_append_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int format = [formatNS intValue];
    int res = CPRCEN_engine_channel_append_to_file(eng, chan, fname, format);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_force_append_to_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS fname:(NSString*)fnameNS format:(nonnull NSNumber*)formatNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    char * fname = [fnameNS UTF8String];
    int format = [formatNS intValue];
    int res = CPRCEN_engine_channel_force_append_to_file(eng, chan, fname, format);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_channel_no_file:(NSString*)engKey chan:(nonnull NSNumber*)chanNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_engine_channel_no_file(eng, chan);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_channel_synth_type_usel:(NSString*)engKey chan:(nonnull NSNumber*)chanNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int res = CPRCEN_channel_synth_type_usel(eng, chan);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_channel_set_phone_min_max:(NSString*)engKey chan:(nonnull NSNumber*)chanNS min:(nonnull NSNumber*)minNS max:(nonnull NSNumber*)maxNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int min = [minNS intValue];
    int max = [maxNS intValue];
    int res = CPRCEN_channel_set_phone_min_max(eng, chan, min, max);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_channel_set_pipe_length:(NSString*)engKey chan:(nonnull NSNumber*)chanNS pipelen:(nonnull NSNumber*)pipelenNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int chan = [chanNS intValue];
    int pipelen = [pipelenNS intValue];
    int res = CPRCEN_channel_set_pipe_length(eng, chan, pipelen);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_get_trans:(NSString*)abKey i:(nonnull NSNumber*)iNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int i = [iNS intValue];
    CPRC_abuf_trans * res = CPRC_abuf_get_trans(ab, i);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf_trans* wrap_res = [[Wrapped_CPRC_abuf_trans alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_sz:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_trans_sz(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_name:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    char * res = CPRC_abuf_trans_name(t);
    NSString* result = [NSString stringWithUTF8String:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_type:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    enum CPRC_ABUF_TRANS res = CPRC_abuf_trans_type(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_start:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    float res = CPRC_abuf_trans_start(t);
    NSNumber* result = [NSNumber numberWithFloat:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_end:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    float res = CPRC_abuf_trans_end(t);
    NSNumber* result = [NSNumber numberWithFloat:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_start_sample:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_start_sample(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_end_sample:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_end_sample(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_phone_stress:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_phone_stress(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_sapi_viseme:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_sapi_viseme(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_disney_viseme:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_disney_viseme(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_sapi_phoneid:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_sapi_phoneid(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_mac_phoneid:(NSString*)tKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf_trans* wrap_t = (Wrapped_CPRC_abuf_trans*) [wrappedObjects getObj:tKey];
    CPRC_abuf_trans* t = wrap_t.val;
    int res = CPRC_abuf_trans_mac_phoneid(t);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_wav_sz:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_sz(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_wav:(NSString*)abKey i:(nonnull NSNumber*)iNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int i = [iNS intValue];
    short res = CPRC_abuf_wav(ab, i);
    NSNumber* result = [NSNumber numberWithInt:(int)res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_wav_mk:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_mk(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_wav_done:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_done(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_added_wav_sz:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_added_wav_sz(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_mk:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_trans_mk(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_trans_done:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_trans_done(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_wav_srate:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int res = CPRC_abuf_wav_srate(ab);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_riff_save:(NSString*)wavKey fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    char * fname = [fnameNS UTF8String];
    int res = CPRC_riff_save(wav, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_riff_append:(NSString*)wavKey fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    char * fname = [fnameNS UTF8String];
    int res = CPRC_riff_append(wav, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_riff_save_trans:(NSString*)wavKey fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    char * fname = [fnameNS UTF8String];
    int res = CPRC_riff_save_trans(wav, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_riff_buffer:(NSString*)wavKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_wav = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:wavKey];
    CPRC_abuf* wav = wrap_wav.val;
    CPTP_fixedbuf * res = CPRC_riff_buffer(wav);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPTP_fixedbuf* wrap_res = [[Wrapped_CPTP_fixedbuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPTP_fixedbuf_delete:(NSString*)fbKey) {
    Wrapped_CPTP_fixedbuf* wrap_fb = (Wrapped_CPTP_fixedbuf*) [wrappedObjects getObj:fbKey];
    CPTP_fixedbuf* fb = wrap_fb.val;
    CPTP_fixedbuf_delete(fb);
}
RCT_EXPORT_METHOD(CPRC_abuf_copy:(NSString*)abKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    CPRC_abuf * res = CPRC_abuf_copy(ab);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_extract:(NSString*)abKey offset:(nonnull NSNumber*)offsetNS sz:(nonnull NSNumber*)szNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    int offset = [offsetNS intValue];
    int sz = [szNS intValue];
    CPRC_abuf * res = CPRC_abuf_extract(ab, offset, sz);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRC_abuf_delete:(NSString*)abKey) {
    Wrapped_CPRC_abuf* wrap_ab = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:abKey];
    CPRC_abuf* ab = wrap_ab.val;
    CPRC_abuf_delete(ab);
}
RCT_EXPORT_METHOD(CPRC_abuf_append:(NSString*)ab_outKey ab_in:(NSString*)ab_inKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRC_abuf* wrap_ab_out = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:ab_outKey];
    CPRC_abuf* ab_out = wrap_ab_out.val;
    Wrapped_CPRC_abuf* wrap_ab_in = (Wrapped_CPRC_abuf*) [wrappedObjects getObj:ab_inKey];
    CPRC_abuf* ab_in = wrap_ab_in.val;
    CPRC_abuf * res = CPRC_abuf_append(ab_out, ab_in);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRC_abuf* wrap_res = [[Wrapped_CPRC_abuf alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_major_version:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int res = CPRCEN_major_version();
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_minor_version:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int res = CPRCEN_minor_version();
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_revision_number:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int res = CPRCEN_revision_number();
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_speak:(NSString*)engKey text:(NSString*)textNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * text = [textNS UTF8String];
    CPRCEN_wav * res = CPRCEN_engine_speak(eng, text);
    NSString *result;
    if (res == nil)
        result = [NSString stringWithFormat:@"%p", res];
    else {
        Wrapped_CPRCEN_wav* wrap_res = [[Wrapped_CPRCEN_wav alloc] init];
        wrap_res.val = res;
        result = [wrappedObjects addObj:wrap_res];
    }
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_speak_to_file:(NSString*)engKey text:(NSString*)textNS fname:(NSString*)fnameNS resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    char * text = [textNS UTF8String];
    char * fname = [fnameNS UTF8String];
    int res = CPRCEN_engine_speak_to_file(eng, text, fname);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}
RCT_EXPORT_METHOD(CPRCEN_engine_clear:(NSString*)engKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    Wrapped_CPRCEN_engine* wrap_eng = (Wrapped_CPRCEN_engine*) [wrappedObjects getObj:engKey];
    CPRCEN_engine* eng = wrap_eng.val;
    int res = CPRCEN_engine_clear(eng);
    NSNumber* result = [NSNumber numberWithInt:res];
    resolve(result);
}

@end