const fs = require('fs');
const path = require('path');
const os = require('os');

const fileHandler = {
  /**
   * Creates a temporary directory for file processing
   * @returns {string} - Path to temp directory
   */
  createTempDir() {
    const tempDirPath = path.join(os.tmpdir(), `song-processor-${Date.now()}`);
    if (!fs.existsSync(tempDirPath)) {
      fs.mkdirSync(tempDirPath, { recursive: true });
    }
    return tempDirPath;
  },
  
  /**
   * Cleans up temporary files and directories
   * @param {string} filePath - Path to file or directory to remove
   */
  cleanup(filePath) {
    try {
      if (fs.existsSync(filePath)) {
        const stats = fs.statSync(filePath);
        
        if (stats.isDirectory()) {
          fs.rmSync(filePath, { recursive: true, force: true });
        } else {
          fs.unlinkSync(filePath);
        }
      }
    } catch (error) {
      console.error('Error cleaning up files:', error);
    }
  }
};

module.exports = fileHandler;