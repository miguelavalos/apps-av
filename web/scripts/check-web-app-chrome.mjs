#!/usr/bin/env node

import { existsSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = dirname(fileURLToPath(import.meta.url));
const workspaceRoot = resolve(scriptDir, "../../../..");
const productChecks = [
  {
    app: "series-av",
    files: ["public/series-av/apps/web/src/components/series-app-shell.tsx"]
  },
  {
    app: "tune-av",
    files: [
      "public/tune-av/apps/web/src/components/tune-app-shell.tsx",
      "public/tune-av/apps/web/src/components/tune-account-area.tsx"
    ]
  },
  {
    app: "moments-av",
    files: ["public/moments-av/apps/web/src/components/moments-app-shell.tsx"]
  },
  {
    app: "animate-av",
    files: ["public/animate-av/apps/web/src/components/animate-app-shell.tsx"]
  }
];

const sharedChecks = [
  {
    app: "apps-av",
    files: ["public/apps-av/web/src/components/app-shell.tsx"]
  }
];

const forbiddenPatterns = [
  {
    pattern: /accountArea\s*=/,
    message: "AppShell product chrome must not receive an accountArea slot."
  },
  {
    pattern: /<\s*AccountUserButton\b/,
    message: "Product app chrome must not render AccountUserButton."
  },
  {
    pattern: /\bUserButton\b/,
    message: "Product app chrome must not render Clerk UserButton."
  },
  {
    pattern: /\bavatar\b/i,
    message: "Product app chrome must not render account/provider avatars."
  }
];

const failures = [];

for (const check of [...sharedChecks, ...productChecks]) {
  for (const file of check.files) {
    const path = resolve(workspaceRoot, file);
    if (!existsSync(path)) {
      continue;
    }
    const source = readFileSync(path, "utf8");
    for (const { message, pattern } of forbiddenPatterns) {
      if (pattern.test(source)) {
        failures.push(`${file}: ${message}`);
      }
    }
  }
}

if (failures.length > 0) {
  console.error("Apps AV web chrome check failed:");
  for (const failure of failures) {
    console.error(`- ${failure}`);
  }
  process.exit(1);
}

console.log("Apps AV web chrome check passed: Avi owns top chrome; no Clerk/account avatar controls found.");
