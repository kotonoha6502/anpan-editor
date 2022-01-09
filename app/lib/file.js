/**
 * 
 * @param {Electron.Dialog} dialog 
 * @returns {Promise<Buffer>}
 */
export function openBinaryFile(dialog) {
  return dialog.showOpenDialog({
    filters: [
      { name: 'ROM Image', extensions: ['nes'] },
    ],
    properties: ['openFile', 'createDirectory']
  })
  .then(async (fileObj) => {
    if (!fileObj.canceled) {
      const buf = await fs.readFile(fileObj.filePaths[0])
      Promise.resolve(buf)
    }
  })
  .catch((err) => {
    console.error(err)
    process.exit(1)
  })
}