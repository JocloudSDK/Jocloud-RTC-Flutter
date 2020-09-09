package com.example.flutterthunder_example

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*


const val tag = "MainActivity"
const val PERMISSION_REQUEST_CODE = 100

class MainActivity: FlutterActivity() {
    private var mPermissions = LinkedList<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initPermissions()
        GeneratedPluginRegistrant.registerWith(this)

    }

    override fun onResume() {
        super.onResume()
    }

    private fun initPermissions() {
        mPermissions.add(Manifest.permission.CAMERA)
        mPermissions.add(Manifest.permission.RECORD_AUDIO)
        mPermissions.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        mPermissions.add(Manifest.permission.READ_EXTERNAL_STORAGE)
        checkPermissions()
    }

    private fun checkPermissions() {
        if (mPermissions.isEmpty()) return
        if (ContextCompat.checkSelfPermission(this, mPermissions.getFirst()) != PackageManager.PERMISSION_GRANTED) {
            Log.d(tag, "checkPermission () ")
            ActivityCompat.requestPermissions(this, arrayOf(mPermissions.getFirst()), PERMISSION_REQUEST_CODE)
        } else {
            mPermissions.removeFirst()
            checkPermissions()
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>,
                                            grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.size >= 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                mPermissions.removeFirst()
                Log.d(tag, "onRequestPermissionsResult " + grantResults[0] + " -- " + permissions[0])
                if (permissions[0] === Manifest.permission.WRITE_EXTERNAL_STORAGE) {

                }
                checkPermissions()
            } else {
                Log.d(tag, "onRequestPermissionsResult 没有获取到权限")
                val tip = resources.getString(R.string.broadcast_need_these_permission)
                Toast.makeText(this, tip, Toast.LENGTH_LONG).show()
                finish()
            }
        }
    }

}
