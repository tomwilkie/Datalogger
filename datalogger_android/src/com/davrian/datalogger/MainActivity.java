package com.davrian.datalogger;

import java.io.BufferedReader;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelFileDescriptor;
import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbAccessory;
import android.hardware.usb.UsbManager;
import android.view.Menu;
import android.widget.EditText;

public class MainActivity extends Activity {

	private void setupConnection(UsbAccessory accessory) {
    	log("setupConnection()");
    	
    	UsbManager mUsbManager = (UsbManager) getSystemService(Context.USB_SERVICE);
    	log(" permission: " + mUsbManager.hasPermission(accessory));
    	ParcelFileDescriptor mFileDescriptor = mUsbManager.openAccessory(accessory);
    	if (mFileDescriptor != null) {
            FileDescriptor fd = mFileDescriptor.getFileDescriptor();
            FileInputStream mInputStream = new FileInputStream(fd);
            Thread thread = new Thread(null, new USBThread(mInputStream), "AccessoryThread");
            thread.start();
        }
	}
	
	private static final String ACTION_USB_PERMISSION =
		    "com.android.example.USB_PERMISSION";
	private final BroadcastReceiver mUsbReceiver = new BroadcastReceiver() {
	 
	    public void onReceive(Context context, Intent intent) {
	        String action = intent.getAction();
	        log(action);
	        if (ACTION_USB_PERMISSION.equals(action)) {
	            synchronized (this) {
	                UsbAccessory accessory = (UsbAccessory) intent.getParcelableExtra(UsbManager.EXTRA_ACCESSORY);

	                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
	                    if(accessory != null){
	                    	setupConnection(accessory);
	                    }
	                }
	                else {
	                   log("permission denied for accessory " + accessory);
	                }
	            }
	        }
	        else if (UsbManager.ACTION_USB_ACCESSORY_DETACHED.equals(action)) {
	            UsbAccessory accessory = (UsbAccessory)intent.getParcelableExtra(UsbManager.EXTRA_ACCESSORY);
	            if (accessory != null) {
	            	log("disconnected?");
	            }
	        }
	    }
	};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		Intent intent = getIntent();
	    String action = intent.getAction();
	    
	    log(action);
	
	    if (UsbManager.ACTION_USB_ACCESSORY_ATTACHED.equals(action)) {
	    	UsbAccessory accessory = (UsbAccessory) intent.getParcelableExtra(UsbManager.EXTRA_ACCESSORY);
	    	PendingIntent mPermissionIntent = PendingIntent.getBroadcast(this, 0, new Intent(ACTION_USB_PERMISSION), 0);
	    	IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
	    	registerReceiver(mUsbReceiver, filter);
	    	UsbManager mUsbManager = (UsbManager) getSystemService(Context.USB_SERVICE);
	    	mUsbManager.requestPermission(accessory, mPermissionIntent);
	    }
	}
	
	private void readStream(FileInputStream in) {
		log("started");
		
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e2) {
		}
		
		byte[] buffer = new byte[16384];
		ByteBuffer bb = ByteBuffer.wrap(buffer)
				.order(ByteOrder.LITTLE_ENDIAN);
		
		while (true) {
			try {
				bb.clear();
				int len = in.read(buffer);
				log("read " + len + " bytes");
				if (len < 0) {
					continue;
				}
				
				int intended_len = bb.get();
				if (len-1 != intended_len) {
					log("incomplete packet - bugger!! " + intended_len);
					return;
				}
				
				StringBuilder sb = new StringBuilder();
				
				for(int i = 0; i < len/2; i++) {
					sb.append(i + ":" + bb.getShort());
					sb.append("\t\t");
				}
				
				log(sb.toString());
			} catch (IOException e) {
				log(e.toString());
				return;
			}
		}
	}
	
	private class USBThread implements Runnable {
		
		private FileInputStream in;

		public USBThread(FileInputStream in) {
			this.in = in;
		}
		
		@Override
		public void run() {
			readStream(in);
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

	public void log(final String s) {
		if (s == null)
			return;
		
		this.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				EditText text = (EditText) findViewById(R.id.logOutput);
				if (text != null)
					text.getText().append(s).append("\n");
			}
		});
	}
}
