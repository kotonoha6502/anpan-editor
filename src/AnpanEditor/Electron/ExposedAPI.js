exports.onRomFileSelected = function (listener) {
  return () => window.electron.on('rom-file-selected', (filePath) => listener(filePath)() )
}

exports._loadRomFile = function (Left, Right, path) {
  return () => new Promise((resolve) => {
    try {
      window.electron.loadRomFile(path).then(vrom => {
        resolve(Right(vrom))
      })
    } catch (error) {
      resolve(Left(error))
    }
  })
}