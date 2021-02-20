npm install;
npm i -g eslint jsdoc prettier showdown terser toast-jsdoc figlet-cli @babel/core @babel/cli @babel/preset-env @babel/plugin-transform-modules-commonjs
function remove {
  rm -f .git/index.lock
}
function commit {
  COMMIT=$(git status --porcelain)
  cd /workspace/Bijou.js
  rm bijou_node.js
  rm -r docs/docs
  rm bijou-min.js
  eslint --fix ./
  prettier --write -- .
  npm install @babel/preset-env
  babel --plugins @babel/plugin-transform-modules-commonjs --presets=@babel/preset-env -o bijou_node.js -- bijou.js
  terser --comments false --ecma 5 --ie8 --compress --drop-console --mangle -o bijou_node.js -- bijou_node.js
  jsdoc -c jsdoc.json
  babel --presets=@babel/preset-env -o bijou-min.js -- bijou.js
  terser --comments false --ecma 5 --ie8 --module --compress --drop-console --mangle -o bijou-min.js -- bijou-min.js
  if [[ ${#COMMIT} -ge 1 ]] ; then
    echo "Commit message?   "
    read COMMIT_CUSTOM_MSG
    COMMIT_FILE=$(git diff --name-only)
    git stage .
    DATE=$(date +"%F %H:%M:%S")
    USER=$(git config user.name)
    EMAIL=$(git config user.email)
    REPO="BIJOU.JS"
    FIGLET_REPO=$(figlet -kf Big -- $REPO)
    BR=$'\n'
    COMMIT_MSG=$"${FIGLET_REPO}${BR}Files changed: ${BR}${BR}${COMMIT}${BR}${BR}Date: ${DATE}${BR}User: ${USER}${BR}Email: ${EMAIL}"
    git commit -m "${COMMIT_CUSTOM_MSG} ${COMMIT_FILE}" -m "${COMMIT_MSG}"
  fi
}

remove
commit
git push