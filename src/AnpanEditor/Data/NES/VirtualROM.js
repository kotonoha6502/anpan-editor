/**
 * 
 * @param {Buffer} buf 
 * @returns 
 */
exports.unsafeShowBuf = function (buf) {
  const len = buf.length
  const sfx = len > 32 ? "..." : ""
  let res = "Buffer <"
  for (byte in buf) {
    res += byte + " "
  }
  return res + sfx + ">"
}