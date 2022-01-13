module.exports = {
  /**
   * 
   * @param {Buffer} header
   */
  decodeHeader: function (header) {
    // iNESヘッダーか？
    if (header.toString('ascii', 0, 3) !== "NES"
    || header.readUInt8(3) !== 0x1A // MS-DOS end-of-file
    ) {
      throw new Error("ROMイメージの読み込みに失敗しました。");
    }

    // PRG-ROMサイズ（16KiB単位）
    const prgRomSize = header.readUInt8(4);
    // CHR-ROMサイズ(8KiB単位)
    const chrRomSize = header.readUInt8(5);

    // ミラーリング、バッテリーバックアップ、トレイナー
    const flag6 = header.readUInt8(6);
    const mirroring = (flag6 & 0x01) ? 'vertical' : 'horizontal';
    const hasBatteryRAM = (flag6 & 0x02) ? true : false; 
    const hasTrainer = flag6 & 0x04 ? true : false;
    const fourScreenMirroring = flag6 & 0x08 ? true : false

    // マッパー番号
    const flag7 = header.readUInt8(7);
    const mapper = (flag7 & 0xF0) << 4 | ((flag6 & 0xF0) >> 4);

    return {
      prgRomSize,
      chrRomSize,
      mirroring,
      hasBatteryRAM,
      hasTrainer,
      fourScreenMirroring,
      mapper,
    }
  }
}