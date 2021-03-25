/* Copyright (c) 2016 CereProc Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.art.cere.plugins;

import android.media.AudioTrack;
import android.util.Log;

import com.cereproc.cerevoice_eng.*;

public class DemoCallback extends TtsEngineCallback {

    private static final String TAG = "DemoCallback"; // Tag for logger
    private AudioTrack audioTrack;

    /**
     * The constructor of the custom callback class
     *
     * The new constructor should call the super
     */
    public DemoCallback(AudioTrack a) {
        audioTrack = a;
    }

    /**
     * The Callback function is fired periodically throughout the synthesis.
     *
     * In CereVoice, a callback can be specified to receive data every time a phrase
     * has been synthesised. The user application can process that data safely, as
     * the engine does not continue until the user returns from the callback.
     * Ideally, the processing done in the callback itself should be kept simple,
     * such as sending audio data to the audio player, or sending timed phonetic
     * information to a separate thread for lip animation on a talking head.
     *
     * @param abuf Cereproc Audio Buffer
     */
    public void Callback(SWIGTYPE_p_CPRC_abuf abuf) {
        audioTrack.play();
        Log.i(TAG, "Firing engine callback");
        // an example use is to get information about the progress
        // int trans_mk = cerevoice_eng.CPRC_abuf_trans_mk(abuf);
        // int trans_done = cerevoice_eng.CPRC_abuf_trans_done(abuf);
        // for (int i = trans_mk; i < trans_done; i++) {

        // SWIGTYPE_p_CPRC_abuf_trans trans;
        // CPRC_ABUF_TRANS_TYPE transType;
        // float start, end;
        // String name;

        // trans = cerevoice_eng.CPRC_abuf_get_trans(abuf, i);
        // transType = cerevoice_eng.CPRC_abuf_trans_type(trans);
        // start = cerevoice_eng.CPRC_abuf_trans_start(trans);
        // end = cerevoice_eng.CPRC_abuf_trans_end(trans);
        // name = cerevoice_eng.CPRC_abuf_trans_name(trans);
        // if (transType == CPRC_ABUF_TRANS_TYPE.CPRC_ABUF_TRANS_PHONE) {
        // Log.i(TAG, String.format("phoneme: %.3f %.3f %s\n", start, end, name));
        // } else if (transType == CPRC_ABUF_TRANS_TYPE.CPRC_ABUF_TRANS_WORD) {
        // Log.i(TAG, String.format("word: %.3f %.3f %s\n", start, end, name));
        // } else if (transType == CPRC_ABUF_TRANS_TYPE.CPRC_ABUF_TRANS_MARK) {
        // Log.i(TAG, String.format("marker: %.3f %.3f %s\n", start, end, name));
        // } else if (transType == CPRC_ABUF_TRANS_TYPE.CPRC_ABUF_TRANS_ERROR) {
        // Log.i(TAG, String.format("could not retrieve transcription at '%d'", i));
        // }
        // }

        // Another example usage of the callback is to play the audio
        // this is the recommended approach as it is safe to use the audio in the
        // callback
        // Copy the audio buffer into a byte array for Android to then pass to the audio
        // track
        int wav_added = cerevoice_eng.CPRC_abuf_added_wav_sz(abuf);
        int wav_mk = cerevoice_eng.CPRC_abuf_wav_mk(abuf);
        short[] outBuffer = new short[wav_added];
        for (int i = 0; i < wav_added; i++) {
            outBuffer[i] = cerevoice_eng.CPRC_abuf_wav(abuf, wav_mk + i);
        }
        audioTrack.write(outBuffer, 0, outBuffer.length);

    }
}
