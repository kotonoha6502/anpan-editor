const {
  contextBridge,
  ipcRenderer,
} = require('electron');
const fs = require('fs/promises');
const { resolve } = require('path');
const path = require('path');
const { decodeHeader } = require('./lib/nesrom')

contextBridge.exposeInMainWorld('electron', {
  vrom: null,
  nyan: async (data) => ipcRenderer.invoke('nyan', data),
  loadRomFile: async (filePath) => {
    const buf = await fs.readFile(filePath)
    // read iNES header
    const header = Buffer.alloc(16, 0xFF);
    buf.copy(header, 0, 0, 16);
    const romSpec = decodeHeader(header)

    // PRG-ROM
    const prgRom = Buffer.alloc(romSpec.prgRomSize * 0x4000, 0xFF);
    const prgRomOffset = 16 + (romSpec.hasTrainer ? 512 : 0);
    buf.copy(prgRom, 0, prgRomOffset);

    // トレイナー領域
    if (romSpec.hasTrainer) {
      const trainer = Buffer.alloc(512, 0xFF);
      buf.copy(trainer, 0, 512);
    }

    // CHR-ROM
    const chrRom = Buffer.alloc(romSpec.chrRomSize * 0x2000, 0xFF);
    const chrRomOffset = prgRomOffset + romSpec.prgRomSize * 0x4000;   
    buf.copy(chrRom, 0, chrRomOffset);

    this.vrom = {
      romSpec,
      meta: {
        filename: path.basename(filePath),
        directory: path.dirname(filePath),  
      },
      base: {
        header: header,
        prg: prgRom,
        char: chrRom,
        ...(romSpec.hasTrainer ? { trainer } : {})
      }
    }

    return this.vrom
  },

  on: (channel, listener) => {
    ipcRenderer.on(channel, (evt, ...args) => {
      listener(...args)
    })
  }
})