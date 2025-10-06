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
    // Check if it looks like base64
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
 * Log debug information to /tmp/ccr_server.log
 */
export function debugLog(topic: string, data: LogData = {}) {
  const timestamp = new Date().toISOString();
  const truncatedData = truncateBase64(data);

  const logEntry = {
    timestamp,
    topic,
    ...truncatedData
  };

  const logLine = `\n${'='.repeat(80)}\n${JSON.stringify(logEntry, null, 2)}\n${'='.repeat(80)}\n`;

  try {
    appendFileSync(LOG_FILE, logLine);
  } catch (err) {
    console.error('Failed to write to debug log:', err);
  }
}
