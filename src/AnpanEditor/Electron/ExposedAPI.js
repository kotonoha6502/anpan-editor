exports._nyan = function (data) {
  return () => window.electron.nyan(data)
}