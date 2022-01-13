exports.unsafeConsoleLog = function (x) {
  return () => console.log(x)
}