package com.example.fnode

import io.flutter.embedding.android.FlutterActivity;
import com.clostra.newnode.NewNode;
import android.os.Bundle

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState);
    NewNode.init();
  }
}
