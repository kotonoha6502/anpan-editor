/**
 * 
 * @param {Buffer} buf 
 * @return {array<number>}
 */
exports.ufferToByteArray= function (buf) {
  if (buf.length <= 0) return [];

  let ret = new Array(buf.length)
  for (let i = 0; i < buf.length; i++) {
    ret[i] = buf[i];
  }
  return ret;
}