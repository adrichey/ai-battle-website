#!/bin/sh
service postgresql start
node ./node_modules/.bin/knex migrate:latest --knexfile=./database/config/knexfile.js
su - postgres -c 'cd /app; psql jsfightclub < ./node_modules/connect-pg-simple/table.sql'
node gamerunner/run-test-game.js
npm run build
node server.js --no-github