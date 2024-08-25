package com.example.nativehost;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.material.tabs.TabLayout;


import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends AppCompatActivity {
    private static final String CHANNEL = "com.example.nativehost/channel";
    private static final String ENGINE_ID = "my_engine_id";
    Button flutterButton;
    private TabLayout tabLayout;
    private FrameLayout flutterContainer;
    FlutterFragment flutterFragment;
    FragmentManager fragmentManager;
    boolean isFlutterVisible = false;
    FlutterEngine flutterEngine;

    private TextView homeTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize Flutter engine
        flutterEngine = FlutterEngineCache.getInstance().get(ENGINE_ID);
        if (flutterEngine == null) {
            flutterEngine = new FlutterEngine(this);
            flutterEngine.getDartExecutor().executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
            );

            // Register Method Channel
            new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                    .setMethodCallHandler((call, result) -> {
                        if (call.method.equals("getMessage")) {
                            String message = "Hello from Native Android";
                            Log.d("MainActivity", "Sending message: " + message);
                            result.success(message);
                        } else {
                            result.notImplemented();
                        }
                    });

            // Cache the FlutterEngine to be used by FlutterFragment
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine);
        }

        // Attach FlutterFragment
        fragmentManager = getSupportFragmentManager();
        flutterFragment = FlutterFragment.withCachedEngine(ENGINE_ID).build();
        tabLayout = findViewById(R.id.tabLayout);
        flutterContainer = findViewById(R.id.flutter_container);

        fragmentManager = getSupportFragmentManager();
        flutterContainer.setVisibility(View.GONE);
        homeTextView = findViewById(R.id.homeTextView);


        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(@NonNull TabLayout.Tab tab) {
                FragmentTransaction transaction = fragmentManager.beginTransaction();
                switch (tab.getPosition()) {
                    case 0:
                        // Tab 1 (Home) selected, show homeTextView
                        homeTextView.setVisibility(View.VISIBLE);
                        flutterContainer.setVisibility(View.GONE);
                        if (isFlutterVisible) {
                            transaction.remove(flutterFragment).commit();
                            isFlutterVisible = false;
                        }
                        break;
                    case 1:
                        // Tab 3 selected, show FlutterFragment
                        if (!isFlutterVisible) {
                            transaction.replace(R.id.flutter_container, flutterFragment).commit();
                            isFlutterVisible = true;
                        }
                        flutterContainer.setVisibility(View.VISIBLE);
                        break;
                    default:
                        // Any other tab selected, hide FlutterFragment
                        homeTextView.setVisibility(View.GONE);
                        if (isFlutterVisible) {
                            transaction.remove(flutterFragment).commit();
                            isFlutterVisible = false;
                        }
                        flutterContainer.setVisibility(View.GONE);
                        break;
                }
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
                // No action needed for this example
            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {
                // No action needed for this example
            }
        });
//        flutterButton = findViewById(R.id.flutterButton);
//        flutterButton.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                FragmentTransaction transaction = fragmentManager.beginTransaction();
//                if (isFlutterVisible) {
//                    transaction.remove(flutterFragment).commit();
//                    flutterButton.setText("Show Flutter Screen");
//                } else {
//                    transaction.replace(R.id.flutter_container, flutterFragment).commit();
//                    flutterButton.setText("Hide Flutter Screen");
//                }
//                isFlutterVisible = !isFlutterVisible;
//            }
//        });

        // Handle input from EditText
        EditText nativeInput = findViewById(R.id.nativeInput);
        nativeInput.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                Log.d("asdasdsa","dari input");
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    // Tindakan yang diambil saat "Enter" ditekan
                    String inputText = nativeInput.getText().toString();

                    // Send input to Flutter
                    try {
                        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                                .invokeMethod("sendInput", "test dari native:" + inputText);
                        // Clear the input field

                        nativeInput.setText("");
                    } catch (Exception e) {
                        Log.e("MainActivity", "Error sending input to Flutter", e);
                        Toast.makeText(MainActivity.this, "Error sending input to Flutter", Toast.LENGTH_SHORT).show();
                    }
                    return true;
                }
                return false;
            }
        });
    }
}
