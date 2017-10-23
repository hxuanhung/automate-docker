/* eslint-disable */
const shell = require("shelljs");
const program = require("commander");

const cwd = process.cwd();
const pkg = require(`${cwd}/package.json`);
const run = function(cmd) {
  console.log("run", cmd);
  const resp = shell.exec(cmd);
  if (resp.code != 0) {
    throw resp.stderr;
  }
};
program
  .version("0.0.1")
  .option("-d, --dev", "if build dev")
  .option("-b, --build", "if build first")
  .option("-u, --username [username]", "hub username")
  .option("-p, --password [password]", "hub password")
  .option("-s, --server [server]", "hub server")
  .option("-f, --file [dockerfile]", "dockerfile", "Dockerfile")
  .option("-n, --imageName [imagename]", "image name")
  .option(
    "-a, --action [action]",
    "docker action: build, push. default to build",
    "build",
  )
  .parse(process.argv);

shell.cd(cwd);
const name = program.imageName || pkg.name;
const cmd = `build${program.dev ? ":dev" : ""}`;
const imageName = `${name}:${pkg.version}`;
const latestImageName = `${name}:latest`;
const runBuild = function() {
  // run(`yarn ${cmd}`);
  run(`docker build . -f ${program.file} -t ${imageName}`);
  // run(`docker build . -f ${program.file} -t ${imageName} --no-cache=true`);
  run(`docker tag ${imageName} ${latestImageName}`);
};
const runPush = function() {
  if (!program.password || !program.username || !program.server) {
    throw "password, username and server are required for development";
  }
  run(`docker tag ${imageName} ${program.server}/${imageName}`);
  run(`docker tag ${imageName} ${program.server}/${latestImageName}`);
  run(
    `docker login -u ${program.username} -p ${program.password} ${program.server} `,
  );
  run(`docker push ${program.server}/${imageName}`);
  run(`docker push ${program.server}/${latestImageName}`);
};

if (program.action === "push") {
  if (program.build) {
    runBuild();
  }
  runPush();
} else {
  runBuild();
}
