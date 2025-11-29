# Init Astro

## clone github repo

```bash
git clone git@github.com:kobayashirei/blog.git
```

## install node.js

```bash
# windows
winget install nodejs
```

## install pnpm

```bash
npm install -g pnpm
```

## install modules

```bash
pnpm install
```

# Astro Blog Deploy

```bash
curl -sSL https://raw.githubusercontent.com/kobayashirei/blog/main/deploy.sh | bash -s -- kobayashirei blog 14000
```