package com.princess.plataforma

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.view.View
import android.webkit.*
import android.widget.ProgressBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var swipeRefresh: SwipeRefreshLayout
    private lateinit var progressBar: ProgressBar

    private var filePathCallback: ValueCallback<Array<Uri>>? = null
    private var cameraImageUri: Uri? = null

    companion object {
        private const val HUB_URL = "https://centralcomprasprincesscanarias.github.io/princess-data/hub.html"
        private const val FILE_CHOOSER_REQUEST = 1001
        private const val CAMERA_PERMISSION_REQUEST = 1002
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Pantalla completa sin barra de título
        supportActionBar?.hide()
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE

        setContentView(R.layout.activity_main)

        webView = findViewById(R.id.webView)
        swipeRefresh = findViewById(R.id.swipeRefresh)
        progressBar = findViewById(R.id.progressBar)

        setupWebView()
        setupSwipeRefresh()

        if (savedInstanceState != null) {
            webView.restoreState(savedInstanceState)
        } else {
            webView.loadUrl(HUB_URL)
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView() {
        val settings = webView.settings
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        settings.databaseEnabled = true
        settings.loadWithOverviewMode = true
        settings.useWideViewPort = true
        settings.setSupportZoom(false)
        settings.builtInZoomControls = false
        settings.displayZoomControls = false
        settings.allowFileAccess = true
        settings.mediaPlaybackRequiresUserGesture = false
        settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        settings.cacheMode = WebSettings.LOAD_DEFAULT
        settings.userAgentString = settings.userAgentString + " PrincessPlataforma/1.0"

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, request: WebResourceRequest): Boolean {
                val url = request.url.toString()
                // Abrir enlaces externos en navegador
                if (!url.contains("centralcomprasprincesscanarias.github.io") &&
                    !url.contains("ifiwuloipapsezmssyda.supabase.co") &&
                    !url.contains("raw.githubusercontent.com") &&
                    url.startsWith("http")) {
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                    return true
                }
                return false
            }

            override fun onPageStarted(view: WebView, url: String, favicon: android.graphics.Bitmap?) {
                progressBar.visibility = View.VISIBLE
            }

            override fun onPageFinished(view: WebView, url: String) {
                progressBar.visibility = View.GONE
                swipeRefresh.isRefreshing = false
            }

            override fun onReceivedError(view: WebView, request: WebResourceRequest, error: WebResourceError) {
                if (request.isForMainFrame) {
                    swipeRefresh.isRefreshing = false
                    progressBar.visibility = View.GONE
                    // Mostrar página de error offline
                    view.loadData(getOfflinePage(), "text/html", "UTF-8")
                }
            }
        }

        webView.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView, newProgress: Int) {
                progressBar.progress = newProgress
            }

            // Soporte para subida de archivos/fotos (incidencias)
            override fun onShowFileChooser(
                webView: WebView,
                filePathCallback: ValueCallback<Array<Uri>>,
                fileChooserParams: FileChooserParams
            ): Boolean {
                this@MainActivity.filePathCallback?.onReceiveValue(null)
                this@MainActivity.filePathCallback = filePathCallback

                if (ContextCompat.checkSelfPermission(this@MainActivity, Manifest.permission.CAMERA)
                    != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(
                        this@MainActivity,
                        arrayOf(Manifest.permission.CAMERA),
                        CAMERA_PERMISSION_REQUEST
                    )
                    return true
                }

                launchFileChooser()
                return true
            }
        }
    }

    private fun launchFileChooser() {
        // Intent para cámara
        val cameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        val photoFile = createImageFile()
        cameraImageUri = FileProvider.getUriForFile(this, "$packageName.provider", photoFile)
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, cameraImageUri)

        // Intent para galería
        val galleryIntent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)

        val chooser = Intent.createChooser(galleryIntent, "Seleccionar imagen")
        chooser.putExtra(Intent.EXTRA_INITIAL_INTENTS, arrayOf(cameraIntent))
        startActivityForResult(chooser, FILE_CHOOSER_REQUEST)
    }

    private fun createImageFile(): File {
        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        val storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile("IMG_${timestamp}_", ".jpg", storageDir)
    }

    private fun setupSwipeRefresh() {
        swipeRefresh.setColorSchemeColors(
            ContextCompat.getColor(this, R.color.gold)
        )
        swipeRefresh.setOnRefreshListener {
            webView.reload()
        }
    }

    private fun getOfflinePage(): String {
        return """
            <!DOCTYPE html>
            <html lang="es">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body { background: #1a1510; font-family: -apple-system, sans-serif; 
                           display: flex; flex-direction: column; align-items: center; 
                           justify-content: center; min-height: 100vh; margin: 0; color: #d4b483; }
                    .icon { font-size: 56px; margin-bottom: 20px; }
                    h2 { margin: 0 0 10px; font-size: 20px; color: #f7f4f0; }
                    p { margin: 0 0 28px; font-size: 14px; color: #9a9088; text-align: center; padding: 0 32px; }
                    button { background: #b08d57; color: #1a1510; border: none; border-radius: 12px;
                             padding: 13px 28px; font-size: 15px; font-weight: 700; cursor: pointer; }
                </style>
            </head>
            <body>
                <div class="icon">📡</div>
                <h2>Sin conexión</h2>
                <p>La plataforma Princess requiere conexión a internet. Comprueba tu red e inténtalo de nuevo.</p>
                <button onclick="location.reload()">Reintentar</button>
            </body>
            </html>
        """.trimIndent()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == FILE_CHOOSER_REQUEST) {
            if (resultCode == Activity.RESULT_OK) {
                val uri = data?.data ?: cameraImageUri
                filePathCallback?.onReceiveValue(if (uri != null) arrayOf(uri) else null)
            } else {
                filePathCallback?.onReceiveValue(null)
            }
            filePathCallback = null
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CAMERA_PERMISSION_REQUEST) {
            launchFileChooser()
        }
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        webView.saveState(outState)
    }
}
