package com.smoothie.wirelessDebuggingSwitch;

import android.content.Context;
import android.debug.IAdbManager;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Keep;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import rikka.shizuku.SystemServiceHelper;

public class UserService extends IUserService.Stub {

    private static final String TAG = "UserService";

    @Keep
    public UserService() {
        Log.d(TAG, "UserService initialized without a context");
    }

    @Keep
    public UserService(Context context) {
        Log.d(TAG, "UserService initialized with context");
    }

    @Override
    public void destroy() {
        Log.d(TAG, "UserService destroyed");
        System.exit(0);
    }

    @Override
    public String executeShellCommand(String command) {
        Process process = null;
        String output = "";

        try {
            Log.d(TAG, "Executing shell command: " + command);
            process = Runtime.getRuntime().exec(command);
            InputStream stream = process.getInputStream();
            process.waitFor();
            output = new BufferedReader(new InputStreamReader(stream)).readLine();

            // If a command produces no output, BufferedReader.readLine() will return null
            if (output == null)
                output = "";
        }
        catch (Exception exception) {
            Log.w(TAG, "Exception in executeShellCommand(...)");
            Log.w(TAG, Log.getStackTraceString(exception));
            output = "";
        }
        finally {
            if (process != null)
                process.destroy();
        }

        return output;
    }

    @Override
    public int getWirelessAdbPort() {
        Log.d(TAG, "Acquiring Wireless ADB port");
        try {
            IBinder service = SystemServiceHelper.getSystemService("adb");
            if (service != null) {
                IAdbManager manager = IAdbManager.Stub.asInterface(service);
                int port = manager.getAdbWirelessPort();
                if (port > 0) {
                    Log.d(TAG, "Wireless ADB port value: " + port);
                    return port;
                }
            }
        } catch (Exception e) {
            Log.w(TAG, "Failed to get port from IAdbManager, trying fallback method");
        }
        
        // Fallback: read from system property
        String portStr = executeShellCommand("getprop service.adb.tcp.port");
        if (portStr == null || portStr.isEmpty()) {
            portStr = executeShellCommand("getprop service.adb.tls.port");
        }
        
        try {
            int port = Integer.parseInt(portStr.trim());
            Log.d(TAG, "Wireless ADB port value (fallback): " + port);
            return port > 0 ? port : 5555;
        } catch (NumberFormatException e) {
            Log.w(TAG, "Invalid port value: " + portStr);
            return 5555;
        }
    }

}
