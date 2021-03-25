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

import { NativeModules, DeviceEventEmitter, Platform, NativeEventEmitter } from 'react-native';
const { CerevoiceEng } = NativeModules;
CerevoiceEng.CPRC_abuf_wav_array = async (abuf) => {
  // fetching buffer
  var s = await CerevoiceEng.CPRC_abuf_wav_encoded(abuf);
  
  // ------ CONVERT ENCODED BUFFER INTO SHORT ARRAY ------
  var base64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  let byte_arr = [];
  var base64inv = {};
  for (var i = 0; i < base64chars.length; i++)
  {
    base64inv[base64chars[i]] = i;
  }
  // decoding encoded byte array
  s = s.replace(new RegExp('[^'+base64chars.split("")+'=]', 'g'), "");
  var p = (s.charAt(s.length-1) == '=' ?
          (s.charAt(s.length-2) == '=' ? 'AA' : 'A') : "");
  var r = "";
  s = s.substr(0, s.length - p.length) + p;
  for (var c = 0; c < s.length; c += 4) {
    var n = (base64inv[s.charAt(c)] << 18) + (base64inv[s.charAt(c+1)] << 12) +
            (base64inv[s.charAt(c+2)] << 6) + base64inv[s.charAt(c+3)];
    byte_arr.push((n >>> 16) & 255, (n >>> 8) & 255, n & 255);
  }

  // from byte array to short array
  var out_arr = [];
  var num1, num2;
  for(var i = 0; i < byte_arr.length; i+=2) {
    num1 = (byte_arr[i]>127?byte_arr[i]-127:byte_arr[i]+128);
    num2 = (byte_arr[i+1]>127?byte_arr[i+1]-127:byte_arr[i+1]+128);
    out_arr.push((num1*255+num2)-32768);
  }
  return out_arr;
}

// Handeling callbacks
CerevoiceEng.UserData = {};
CerevoiceEng.internal_callback = async (e) => {
  var abuf = e.abuf;
  var id = e.cbid
  var data = CerevoiceEng.UserData[id];
  await data.cb_funct(abuf, data.user_data);
  CerevoiceEng.CPRCEN_engine_callback_end(data.cb_name);
}
CerevoiceEng.CPRCEN_engine_set_callback = async (eng, chan, userdata, callback) => {
  // generate id
  var id = Math.random().toString(36).substring(2,10);
  var cb_name = await CerevoiceEng.CPRCEN_engine_set_callback_wrapped(eng, chan, id);
  CerevoiceEng.UserData[id] = {
    cb_funct: callback,
    cb_name: cb_name,
    user_data: userdata,
    eng: eng,
    chan: chan
  }
  // add listener for the callback event
  if (Platform.OS == 'android')
    DeviceEventEmitter.addListener(cb_name, CerevoiceEng.internal_callback);
  else if (Platform.OS == 'ios') {
    CerevoiceEngEmitter = new NativeEventEmitter(CerevoiceEng);
    CerevoiceEngEmitter.addListener(cb_name, CerevoiceEng.internal_callback);
  }
}
CerevoiceEng.CPRCEN_engine_get_channel_userdata = (eng, chan) => {
  for (var key in CerevoiceEng.UserData) {
    if (CerevoiceEng.UserData[key].eng == eng && CerevoiceEng.UserData[key].chan == chan)
      return CerevoiceEng.UserData[key].user_data;
  }
  return null;
}

if (Platform.OS == 'android') {
  CerevoiceEng.null = () => {
    return '0x0';
  }
}  CerevoiceEng.CPRCEN_INTERRUPT_BOUNDARY_TYPE = {
    'CPRCEN_INTERRUPT_BOUNDARY_PHONE': 0,
    'CPRCEN_INTERRUPT_BOUNDARY_WORD': 1,
    'CPRCEN_INTERRUPT_BOUNDARY_NATURAL': 2,
    'CPRCEN_INTERRUPT_BOUNDARY_DEFAULT': 2,
    'CPRCEN_INTERRUPT_BOUNDARY_LEGACY_SPURT': 3
  };
  CerevoiceEng.CPRC_SYLVAL = {
    'CPRC_UNDEF': 0,
    'CPRC_NUC': 1,
    'CPRC_ONSET': 2,
    'CPRC_CODA': 3,
    'CPRC_SYLB': -1
  };
  CerevoiceEng.CPRC_ABUF_TRANS = {
    'CPRC_ABUF_TRANS_PHONE': 0,
    'CPRC_ABUF_TRANS_WORD': 1,
    'CPRC_ABUF_TRANS_MARK': 2,
    'CPRC_ABUF_TRANS_ERROR': 3,
    'CPRC_ABUF_TRANS_TYPES': 4
  };
  CerevoiceEng.CPRC_VOICE_LOAD_TYPE = {
    'CPRC_VOICE_LOAD': 0,
    'CPRC_VOICE_LOAD_EMB': 1,
    'CPRC_VOICE_LOAD_EMB_AUDIO': 2,
    'CPRC_VOICE_LOAD_MEMMAP': 3,
    'CPRC_VOICE_LOAD_TP': 4
  };
  CerevoiceEng.CPRCEN_INTERRUPT_INTERRUPT_TYPE = {
    'CPRCEN_INTERRUPT_INTERRUPT_HALT': 0,
    'CPRCEN_INTERRUPT_INTERRUPT_OVERLAP': 1,
    'CPRCEN_INTERRUPT_INTERRUPT_POLITE': 2,
    'CPRCEN_INTERRUPT_INTERRUPT_ANGRY': 3,
    'CPRCEN_INTERRUPT_INTERRUPT_REPLAN': 3
  };
  CerevoiceEng.CPRCEN_AUDIO_FORMAT = {
    'CPRCEN_RAW': 0,
    'CPRCEN_RIFF': 1,
    'CPRCEN_AIFF': 2
  };
export default CerevoiceEng;