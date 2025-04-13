'use strict';

const baseUrl = "/";

function _getWorkerVersion() {
  return null;
}

function _getBaseUrl() {
  return baseUrl;
}

function generateBaseUrl(href) {
  return new URL(href).toString();
}

if (!_flutter) {
  var _flutter = {
    loader: null,
    worker: null
  };
}

const _scriptDir = typeof document !== 'undefined' && document.currentScript ? document.currentScript.src : undefined;

let _flutter_loader = {
  engineInitializer: null
};

async function _loadEntrypoint(options) {
  const { serviceWorkerVersion, serviceWorkerUrl } = options;
  const { engineInitializer } = options;
  const { appRunner } = options;

  // Load the Flutter engine
  await _initializeEngine();

  // Initialize the Flutter engine
  const appRunner = await engineInitializer.initializeEngine({
    renderer: "canvaskit"
  });

  // Run the app
  await appRunner.runApp();
}

async function _initializeEngine() {
  if (typeof window !== 'undefined') {
    window.addEventListener('load', function () {
      // Download main.dart.js
      var scriptTag = document.createElement('script');
      scriptTag.src = 'main.dart.js';
      scriptTag.type = 'application/javascript';
      document.body.append(scriptTag);
    });
  }
}

// Attach public APIs
_flutter.loader = {
  loadEntrypoint: _loadEntrypoint,
};
