const {spawn, spawnSync} = require('child_process');
const {createHash} = require('crypto');
const {watch, readFileSync, existsSync, writeFileSync, rmSync} = require('fs');

const HASH_FILE = 'node_modules/.docker-entry.hash';
const PACKAGE_FILE = 'package.json';

const installDeps = () => {
    let oldHash = null;
    let hash = null;

    if (existsSync(HASH_FILE)) {
        oldHash = readFileSync(HASH_FILE).toString();
    }

    if (existsSync(PACKAGE_FILE)) {
        const buffer = readFileSync(PACKAGE_FILE);
        hash = createHash('sha1').update(buffer).digest('hex').toString();
    }

    if (oldHash !== hash || oldHash === null) {
        const result = spawnSync('npm ci', {
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

// install dependencies every time package.json changes
const watcher = watch(PACKAGE_FILE, () => {
    installDeps();
});

// restart dev process when a source file changes
const appProcess = spawn(process.env.RUN_DEV || 'npm run dev', {
    stdio: 'inherit',
    shell: true,
});

process.on('SIGTERM', () => {
    watcher.close();
    appProcess.kill('SIGTERM');
});
