package com.example.yafa;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import android.util.Log;
import android.net.Uri;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;

import android.app.Activity; 
import android.content.Intent; 
import android.net.Uri; 
import android.os.Bundle; 

import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import io.flutter.plugin.common.MethodCall; 
import io.flutter.plugin.common.MethodChannel; 
import io.flutter.plugin.common.MethodChannel.MethodCallHandler; 
import io.flutter.plugin.common.MethodChannel.Result; 
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/payments";
    private Activity activity;
    private Result finalResult;
    static final String TAG = "UPI INDIA";
    private boolean resultReturned;
   
    static final int uniqueRequestCode = 512078;
  // transaction result: txnId=YBL1fc50dd5a8994f92a67f553121c4283c&txnRef=foodID1290&Status=Failed&responseCode=01
  // transaction result: txnId=UPI0b26adf5825a47b1a89c8ac070bb944f&responseCode=U16&ApprovalRefNo=&Status=FAILURE&txnRef=foodID1290
  // D/UPI INDIA(  491): RAW RESPONSE FROM REQUESTED APP: txnId=YBL562dd1b85f544eb6bf237101eff38f72&txnRef=foodID1290&Status=Success&responseCode=00
  // I/flutter (  491): transaction result: txnId=YBL562dd1b85f544eb6bf237101eff38f72&txnRef=foodID1290&Status=Success&responseCode=00
  
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
      super.configureFlutterEngine(flutterEngine);
      GeneratedPluginRegistrant.registerWith(flutterEngine);
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
         new MethodCallHandler() {
            @Override 
            public void onMethodCall(MethodCall call, Result result) {
              finalResult = result;
               if (call.method.equals("getUpiApps")) 
                getUpiApps(result);
              else if(call.method.equals("startTransaction"))
                startTransaction(call,result);
              else  
                result.notImplemented(); 
               
            }
         }
      ); 
   }
     private void getUpiApps( Result result) {
      activity = this;
      List<Map<String, Object>> packages = new ArrayList<>();
        Intent intent = new Intent(Intent.ACTION_VIEW);
        String uriString = "upi://pay?pa=test@upi&pn=Test&tn=GetAllApps&am=10.00&cu=INR&mode=04";
        Uri uri = Uri.parse(uriString);
        intent.setData(uri);

        if (activity == null) {
          result.error("activity_missing", "No attached activity found!", null);
          return;
      }

      PackageManager pm = activity.getPackageManager();
      List<ResolveInfo> resolveInfoList = pm.queryIntentActivities(intent, 0);
      
      for (ResolveInfo resolveInfo : resolveInfoList) {
      
        try {
          // Get Package name of the app.
          String packageName = resolveInfo.activityInfo.packageName;
          String name = (String) pm.getApplicationLabel(pm.getApplicationInfo(packageName, PackageManager.GET_META_DATA));
          
         // Get app icon as Drawable
         Drawable dIcon = pm.getApplicationIcon(packageName);

         // Convert the Drawable Icon as Bitmap.
         Bitmap bIcon = getBitmapFromDrawable(dIcon);

         // Convert the Bitmap icon to byte[] received as Uint8List by dart.
         ByteArrayOutputStream stream = new ByteArrayOutputStream();
         bIcon.compress(Bitmap.CompressFormat.PNG, 100, stream);
         byte[] icon = stream.toByteArray();

            

          Map<String, Object> m = new HashMap<>();
          m.put("packageName", packageName);
          m.put("name", name);
          m.put("icon", icon);

         

          // Add this app info to the list.
          packages.add(m);
       
        }catch (Exception e) {
          e.printStackTrace();
          result.error("package_get_failed", "Failed to get list of installed UPI apps", null);
          return;
      }

     
   
  }
  result.success(packages);
}

private Bitmap getBitmapFromDrawable(Drawable drawable) {
  Bitmap bmp = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
  Canvas canvas = new Canvas(bmp);
  drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
  drawable.draw(canvas);
  return bmp;
}


private void startTransaction(MethodCall call, Result result){
  
  resultReturned = false;
  String app;
 // String upi_URI = "upi://pay?pa=Q891026402@ybl&pn=Aayush%20fast%20food&mc=5814&mode=04&tr=foodID1250&am=2&cu=INR";
 String upi_URI = "upi://pay?pa="+call.argument("mid")+
                    "&pn="+Uri.encode(call.argument("mn"))+
                    "&am="+Uri.encode(call.argument("am"))+
                    "&tr="+Uri.encode(call.argument("tr"))+
                    "&mc=5814"+"&mode=04"+"cu=INR";

                    Log.d(TAG, "UPI URI: "+upi_URI);

  // Extract the arguments.
  if (call.argument("app") == null) {
      app = "in.org.npci.upiapp";
  } else {
      app = call.argument("app");
  }

  Log.d(TAG, app + " package");
     Uri uri = Uri.parse(upi_URI);

            // Built Query. Ready to call intent.
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(uri);
            intent.setPackage(app);

           
            if (isAppInstalled(app)) {
            activity.startActivityForResult(intent, uniqueRequestCode);
          } else {
              Log.d(TAG, app + " not installed on the device.");
              resultReturned = true;
              result.error("app_not_installed", "Requested app not installed", null);
          }
}



private boolean isAppInstalled(String uri) {
  
  PackageManager pm = activity.getPackageManager();
  try {
      pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
      return true;
  } catch (PackageManager.NameNotFoundException pme) {
      pme.printStackTrace();
      Log.e(TAG, "" + pme);
  }
  return false;
}




@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
 
        if (uniqueRequestCode == requestCode && finalResult != null) {
            if (data != null) {
                try {
                    String response = data.getStringExtra("response");
                    Log.d(TAG, "RAW RESPONSE FROM REQUESTED APP: "+response);
                    if (!resultReturned) finalResult.success(response);
                } catch (Exception ex) {
                    if (!resultReturned) finalResult.error("null_response", "No response received from app", null);
                }
            } else {
                Log.d(TAG, "Received NULL, User cancelled the transaction.");
                if (!resultReturned) finalResult.error("user_canceled", "User canceled the transaction", null);
            }
        }
       //return true;
    }

    
// @Override
// public void onDetachedFromEngine(@NonNull FlutterEngine flutterEngine) {
//     Log.d(TAG, "Detaching from engine");
//     CHANNEL.setMethodCallHandler(null);
// }

// @Override
// public void onAttachedToActivity(@NonNull FlutterEngine flutterEngine) {
//     Log.d(TAG, "Attaching to Activity");
//     activity = flutterEngine.getActivity();
//     flutterEngine.addActivityResultListener(this);
// }

// @Override
// public void onDetachedFromActivityForConfigChanges() {
//     Log.d(TAG, "Detaching from Activity for config changes");
//     activity = null;
// }

// @Override
// public void onReattachedToActivityForConfigChanges(@NonNull FlutterEngine flutterEngine) {
//     Log.d(TAG, "Reattaching to Activity for config changes");
//     activity = flutterEngine.getActivity();
// }

// @Override
// public void onDetachedFromActivity() {
//     Log.d(TAG, "Detached from Activity");
//     activity = null;
// }

}


