const { app, Menu, BrowserWindow, dialog, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs/promises');

const isMac = process.platform === 'darwin';
const appName = "あんぱんえでぃた〜";

let win;

//=================================================================================================
//  メニュー
//=================================================================================================
const menuTemplate = Menu.buildFromTemplate([
  ...(isMac ? [{
    label: appName,
    submenu: [
      {role: 'about', label: `${appName}について`},
      {type: 'separator'},
      {role: 'services', label: 'サービス'},
      {type: 'separator'},
      {role: 'hide', label:`${appName}を隠す`},
      {role: 'hideothers', label: 'ほかを隠す'},
      {role: 'unhide', label: 'すべて表示'},
      {type: 'separator'},
      {role: 'quit', label: `${appName}を終了`}
    ]
  }] : []),
  {
    label: 'ファイル',
    submenu: [
      {
        label: 'ROMを開く',
        accelerator: 'CmdOrCtrl+O',
        click() {
          dialog.showOpenDialog({
            filters: [
              { name: 'ROM Image', extensions: ['nes'] },
            ],
            properties: ['openFile', 'createDirectory']
          })
          .then(async (fileObj) => {
            if (!fileObj.canceled) {
              const buf = await fs.readFile(fileObj.filePaths[0])
              
            }
          })
          .catch((err) => {
            console.error(err)
          })
        }
      },
      { type: 'separator' },
      isMac ? {role:'close', label:'ウィンドウを閉じる'} : {role:'quit', label:'終了'}
    ]
  },
  {
    label: 'ヘルプ',
    role: "help",
    submenu: [
      {
        label: 'バージョン情報',
        click() {
          const versionWindow = new BrowserWindow({
            parent: win,
            modal: true,
            width: 320,
            height: 156,
            resizable: false,
            minimizable: false,
            icon: path.resolve(__dirname, "assets/images/info-icon.png"),
          })
          versionWindow.setMenuBarVisibility(false)
          versionWindow.loadFile("app/html/version.html")
        }
      }
    ]
  }
]);

// メニューを適用する
Menu.setApplicationMenu(menuTemplate);

//=================================================================================================
//  メインウィンドウ生成
//=================================================================================================
const createWindow = () => {
  win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    icon: path.join(__dirname, "assets/app-icon.png")
  })

  if (process.env.NODE_ENV === "development") {
    win.webContents.openDevTools()
  }

  win.loadFile('app/html/index.html')
}

app.whenReady().then(() => {
  createWindow()

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})

//=================================================================================================
//  IPC通信
//=================================================================================================
ipcMain.handle('nyan', (evt, data) => {
  return `${data}にゃん`
})