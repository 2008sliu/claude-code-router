import { appendFileSync } from 'fs';

const LOG_FILE = '/tmp/ccr_server.log';

interface LogData {
  [key: string]: any;
}

/**
 * Truncate base64 image data for readable logging
 */
function truncateBase64(obj: any, maxLength = 100): any {
  if (typeof obj === 'string' && obj.length > maxLength * 2) {
    // Check if it's a data URL (e.g., data:image/png;base64,...)
    const dataUrlMatch = obj.match(/^(data:image\/[^;]+;base64,)(.+)$/);
    if (dataUrlMatch) {
      const header = dataUrlMatch[1];
      const base64Data = dataUrlMatch[2];
      if (base64Data.length > maxLength * 2) {
        return `${header}${base64Data.substring(0, maxLength)}...[${base64Data.length - maxLength * 2} chars]...${base64Data.substring(base64Data.length - maxLength)}`;
      }
    }
    // Check if it looks like pure base64
    if (/^[A-Za-z0-9+/=]+$/.test(obj.substring(0, 100))) {
      return `${obj.substring(0, maxLength)}...[${obj.length - maxLength * 2} chars]...${obj.substring(obj.length - maxLength)}`;
    }
  }

  if (Array.isArray(obj)) {
    return obj.map(item => truncateBase64(item, maxLength));
  }

  if (obj && typeof obj === 'object') {
    const result: any = {};
    for (const [key, value] of Object.entries(obj)) {
      if (key === 'data' && typeof value === 'string' && value.length > 500) {
        result[key] = truncateBase64(value, maxLength);
      } else {
        result[key] = truncateBase64(value, maxLength);
      }
    }
    return result;
  }

  return obj;
}

/**
 * Log debug information to /tmp/ccr_server.log in JSONL format
 */
export function debugLog(topic: string, data: LogData = {}) {
  const timestamp = new Date().toISOString();
  const truncatedData = truncateBase64(data);

  const logEntry = {
    timestamp,
    topic,
    ...truncatedData
  };

  // JSONL format: one JSON object per line, no separators
  const logLine = JSON.stringify(logEntry) + '\n';

  try {
    appendFileSync(LOG_FILE, logLine);
  } catch (err) {
    console.error('Failed to write to debug log:', err);
  }
}
