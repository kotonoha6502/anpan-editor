exports.unsafeConsoleLog = function (x) {
  return () => console.log(x)
}

exports.mutateArrayPush = function (x) {
  return function (arrayRef) {
    return () => {
      return arrayRef.value.push(x)
    }
  }
}