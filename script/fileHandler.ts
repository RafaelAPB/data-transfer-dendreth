import * as fs from 'fs';
const logger = require('simple-node-logger').createSimpleLogger();

class FileHandler {
    private filePath: string;

    constructor(filePath: string) {
        this.filePath = filePath;
        try {
            if (!fs.statSync(this.filePath).isFile) {
                logger.error(`Given filePath ${this.filePath} does not lead to a file`);
            }
        } catch (e) {
            logger.error(e);
        }
    }

    getJSON<T>(): T | undefined {
        try {
            const fileContent = this.read();
            if (!fileContent) return undefined;
            return JSON.parse(fileContent);
        } catch (e) {
            logger.error(e);
            return undefined;
        }
    }

    read(): string | undefined {
        try {
            return fs.readFileSync(this.filePath).toString('utf-8');
        } catch (e) {
            logger.error(e);
            return undefined;
        }
    }

    write(content: string): boolean {
        try {
            fs.writeFileSync(this.filePath,content);
            return true;
        } catch (e) {
            logger.error(e);
            return false;
        }
    }
}

export default FileHandler;
