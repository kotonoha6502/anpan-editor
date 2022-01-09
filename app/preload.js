const {
  contextBridge,
  ipcRenderer,
} = require('electron');

contextBridge.exposeInMainWorld('electron', {
  nyan: async (data) => ipcRenderer.invoke('nyan', data)
})