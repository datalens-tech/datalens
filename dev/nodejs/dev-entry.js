const {spawn, spawnSync} = require('child_process');
const {createHash} = require('crypto');
const {watch, readFileSync, existsSync, writeFileSync, rmSync} = require('fs');

const HASH_FILE = 'node_modules/.docker-entry.hash';

const isPnpm = existsSync('pnpm-lock.yaml');
const LOCK_FILE = isPnpm ? 'pnpm-lock.yaml' : 'package-lock.json';
const INSTALL_CMD = isPnpm ? 'pnpm install --frozen-lockfile' : 'npm ci';
const DEV_CMD = isPnpm ? 'pnpm run dev' : 'npm run dev';

// eslint-disable-next-line no-console
console.log(`\n\x1b[32m[DOCKER ENTRY]\x1b[0m detected package manager: ${isPnpm ? 'pnpm' : 'npm'}`);

const installDeps = () => {
    let oldHash = null;
    let hash = null;

    if (existsSync(HASH_FILE)) {
        oldHash = readFileSync(HASH_FILE).toString();
    }

    if (existsSync(LOCK_FILE)) {
        const buffer = readFileSync(LOCK_FILE);
        hash = createHash('sha1').update(buffer).digest('hex').toString();
    }

    if (oldHash !== hash || oldHash === null) {
        const result = spawnSync(INSTALL_CMD, {
            stdio: 'inherit',
            shell: true,
        });
        if (result.status === 0) {
            writeFileSync(HASH_FILE, hash);
        }
    } else {
        // eslint-disable-next-line no-console
        console.log('\n\x1b[32m[DOCKER ENTRY]\x1b[0m dependencies are up to date');
    }
};

// install before first run
installDeps();

// clear dist/run/client.sock
try {
    rmSync('./dist/run/client.sock', { force: true });
} catch (error) {
    if (error.code === 'ENOTSUP' || error.code === 'ENOENT') {
        // Socket file operations not supported in this environment or file doesn't exist
        console.log('\n\x1b[33m[DOCKER ENTRY]\x1b[0m Socket file cleanup skipped (not supported)');
    } else {
        throw error;
    }
}

// install dependencies every time lock file changes
const watcher = watch(LOCK_FILE, () => {
    installDeps();
});

// restart dev process when a source file changes
const appProcess = spawn(process.env.RUN_DEV || DEV_CMD, {
    stdio: 'inherit',
    shell: true,
});

process.on('SIGTERM', () => {
    watcher.close();
    appProcess.kill('SIGTERM');
});
