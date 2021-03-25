package com.art.cere.plugins;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.util.Log;
import android.content.res.AssetManager;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.io.IOException;
import java.io.FileNotFoundException;
import android.content.Context;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.AudioFormat;
import android.media.AudioAttributes;

import com.cereproc.cerevoice_eng.*;

/** PluginsPlugin */
public class PluginsPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  private AssetManager assetManager;
  private File cachePath;
  private int chan_handle;
  protected DemoCallback callback;
  AudioTrack audioTrack;

  File licenseFile() {
    // copyFilesToCacheIfMissing();
    return new File(cachePath.getPath(), "license.lic");
  }

  File voiceFile() {
    // copyFilesToCacheIfMissing();
    return new File(cachePath.getPath(), "tts.voice");
  }

  private SWIGTYPE_p_CPRCEN_engine eng;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "plugins");
    channel.setMethodCallHandler(this);
    assetManager = flutterPluginBinding.getApplicationContext().getAssets();
    cachePath = flutterPluginBinding.getApplicationContext().getCacheDir();
    System.loadLibrary("cerevoice_eng");

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    System.loadLibrary("cerevoice_eng");
    Log.d("myTag", "ON METH CAL");
    if (call.method.equals("cereEngInit")) {
      copyFilesToCacheIfMissing();
      eng = cerevoice_eng.CPRCEN_engine_new();
      cerevoice_eng.CPRCEN_engine_load_voice(eng, voiceFile().getAbsolutePath(), "",
          CPRC_VOICE_LOAD_TYPE.CPRC_VOICE_LOAD_EMB, licenseFile().getAbsolutePath(), null, null, null // Load as voice
                                                                                                      // // device
      );
      chan_handle = cerevoice_eng.CPRCEN_engine_open_default_channel(eng);
      //cerevoice_eng.CPRCEN_channel_set_pipe_length(eng, chan_handle, 0);
      result.success("Done");
    } else if (call.method.equals("cereSpeak")) {
      final String txtIn = call.argument("text");
      new Thread( new Runnable() { @Override public void run() { 
        
      copyFilesToCacheIfMissing();
      int minSize = AudioTrack.getMinBufferSize(16000, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
      audioTrack = new AudioTrack.Builder()
          .setAudioAttributes(new AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA)
              .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build())
          .setAudioFormat(new AudioFormat.Builder().setEncoding(AudioFormat.ENCODING_PCM_16BIT).setSampleRate(16000)
              .setChannelMask(AudioFormat.CHANNEL_OUT_MONO).build())
          .setBufferSizeInBytes(minSize).build();
     
      byte[] utf8bytes = {};
      try {
        utf8bytes = txtIn.getBytes("UTF-8");
      } catch (UnsupportedEncodingException e) {
        Log.d("myTag", "ERR");
      }
      callback = new DemoCallback(audioTrack);
      callback.SetCallback(eng, chan_handle);
      cerevoice_eng.CPRCEN_engine_channel_speak(eng, chan_handle, txtIn, utf8bytes.length, 1);
      } } ).start();

     
      result.success("Done");
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  void copyFilesToCacheIfMissing() {
    try {
      if (!licenseFile().exists()) {
        InputStream licenseInputStream = assetManager.open("license.lic");
        writeStreamToFile(licenseInputStream, licenseFile());
        Log.d("myTag", "licenseFile added");
      }
      if (!voiceFile().exists()) {
        InputStream voiceInputStream = assetManager.open("tts.voice");
        writeStreamToFile(voiceInputStream, voiceFile());
        Log.d("myTag", "voiceFile added");
      }
    } catch (Exception e) {
      Log.d("myTag", e.getLocalizedMessage());
    }

  }

  void writeStreamToFile(InputStream input, File file) {
    try {
      try (OutputStream output = new FileOutputStream(file)) {
        byte[] buffer = new byte[4 * 1024]; // or other buffer size
        int read;
        while ((read = input.read(buffer)) != -1) {
          output.write(buffer, 0, read);
        }
        output.flush();
      }
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      try {
        input.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

}

// package com.art.cere.plugins;

// import androidx.annotation.NonNull;

// import io.flutter.embedding.engine.plugins.FlutterPlugin;
// import io.flutter.plugin.common.MethodCall;
// import io.flutter.plugin.common.MethodChannel;
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
// import io.flutter.plugin.common.MethodChannel.Result;
// import io.flutter.plugin.common.PluginRegistry.Registrar;
// import android.util.Log;
// import android.content.res.AssetManager;

// import java.io.File;
// import java.io.FileOutputStream;
// import java.io.InputStream;
// import java.io.OutputStream;
// import java.io.UnsupportedEncodingException;
// import java.net.URI;
// import java.io.IOException;
// import java.io.FileNotFoundException;
// import android.content.Context;
// import android.media.AudioManager;
// import android.media.AudioTrack;
// import android.media.AudioFormat;
// import android.media.AudioAttributes;

// import com.cereproc.cerevoice_eng.*;

// /** PluginsPlugin */
// public class PluginsPlugin implements FlutterPlugin, MethodCallHandler {

// private MethodChannel channel;
// private AssetManager assetManager;
// private File cachePath;
// private int chan_handle;
// protected DemoCallback callback;
// AudioTrack audioTrack;

// File licenseFile() {
// // copyFilesToCacheIfMissing();
// return new File(cachePath.getPath(), "license.lic");
// }

// File voiceFile() {
// // copyFilesToCacheIfMissing();
// return new File(cachePath.getPath(), "tts.voice");
// }

// private SWIGTYPE_p_CPRCEN_engine eng;

// @Override
// public void onAttachedToEngine(@NonNull FlutterPluginBinding
// flutterPluginBinding) {
// Log.d("myTag", "ON attttt CAL");
// channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(),
// "plugins");
// channel.setMethodCallHandler(this);
// assetManager = flutterPluginBinding.getApplicationContext().getAssets();
// cachePath = flutterPluginBinding.getApplicationContext().getCacheDir();
// System.loadLibrary("cerevoice_eng");

// }

// @Override
// public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
// System.loadLibrary("cerevoice_eng");
// Log.d("myTag", "ON METH CAL");
// if (call.method.equals("cereEngInit")) {
// copyFilesToCacheIfMissing();
// eng = cerevoice_eng.CPRCEN_engine_new();
// int minSize = AudioTrack.getMinBufferSize(16000,
// AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
// audioTrack = new AudioTrack.Builder()
// .setAudioAttributes(new
// AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_MEDIA)
// .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build())
// .setAudioFormat(new
// AudioFormat.Builder().setEncoding(AudioFormat.ENCODING_PCM_16BIT).setSampleRate(16000)
// .setChannelMask(AudioFormat.CHANNEL_OUT_MONO).build())
// .setBufferSizeInBytes(minSize).build();
// int loaded = cerevoice_eng.CPRCEN_engine_load_voice(eng,
// voiceFile().getAbsolutePath(), "",
// CPRC_VOICE_LOAD_TYPE.CPRC_VOICE_LOAD_EMB, licenseFile().getAbsolutePath(),
// null, null, null // Load as voice // device
// );
// chan_handle = cerevoice_eng.CPRCEN_engine_open_default_channel(eng);
// String txtIn = call.arguments["text"];
// byte[] utf8bytes = {};
// try {
// utf8bytes = txtIn.getBytes("UTF-8");
// } catch (UnsupportedEncodingException e) {
// Log.d("myTag", "ERR");
// }
// cerevoice_eng.CPRCEN_channel_set_pipe_length(eng, chan_handle, 0);
// callback = new DemoCallback(audioTrack);
// callback.SetCallback(eng, chan_handle);
// cerevoice_eng.CPRCEN_engine_channel_speak(eng, chan_handle, txtIn,
// utf8bytes.length, 1);
// result.success("Done");
// } else if (call.method.equals("cereSpeak")) {
// String text = call.argument("text");
// result.success("Done");
// } else {
// result.notImplemented();
// }
// }

// @Override
// public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
// channel.setMethodCallHandler(null);
// }

// void copyFilesToCacheIfMissing() {
// try {
// if (!licenseFile().exists()) {
// InputStream licenseInputStream = assetManager.open("license.lic");
// writeStreamToFile(licenseInputStream, licenseFile());
// Log.d("myTag", "licenseFile added");
// }
// if (!voiceFile().exists()) {
// InputStream voiceInputStream = assetManager.open("tts.voice");
// writeStreamToFile(voiceInputStream, voiceFile());
// Log.d("myTag", "voiceFile added");
// }
// } catch (Exception e) {
// Log.d("myTag", e.getLocalizedMessage());
// }

// }

// void writeStreamToFile(InputStream input, File file) {
// try {
// try (OutputStream output = new FileOutputStream(file)) {
// byte[] buffer = new byte[4 * 1024]; // or other buffer size
// int read;
// while ((read = input.read(buffer)) != -1) {
// output.write(buffer, 0, read);
// }
// output.flush();
// }
// } catch (FileNotFoundException e) {
// e.printStackTrace();
// } catch (IOException e) {
// e.printStackTrace();
// } finally {
// try {
// input.close();
// } catch (IOException e) {
// e.printStackTrace();
// }
// }
// }

// }