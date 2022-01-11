const {
  contextBridge,
  ipcRenderer,
} = require('electron');

window.addEventListener('DOMContentLoaded', () => {
  const el = document.getElementById('app-version')
  if (el) {
    const packageJson = require('./../package.json');
    el.innerText = packageJson?.version
  }
})

contextBridge.exposeInMainWorld('versionAPI', {
  dispose: () => {
    ipcRenderer.invoke('dispose-version-window')
  },
})