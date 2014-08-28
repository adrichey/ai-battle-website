var startStopContainers = require('./container_interaction/start-stop-containers.js');
var communicateWithContainers = require('./container_interaction/communicate-with-containers.js')
var secrets = require('../secrets.js');

//This function will stop existing containers,
//  start containers for each of the users in the provided array,
//  wait until those containers are ready,
//  then pass the appropriate user files into each container.
//Returns a promise
var prepareUserContainers = function(users) {

  //The starting port
  var port = 12499;



  //Make sure all containers are stopped and removed to begin
  console.log('Killing all currently running containers to start...');
  return startStopContainers.shutDownAllContainers().then(function() {
    console.log('All containers stopped...');
  }, function() {
    console.log('All containers were already stopped...');


  //Start a docker container for each user
  }).then(function() {
    console.log('Starting all containers...');

    return Q.all(users.map(function(user) {
      //assign a port to each
      port++;
      user.port = port;

      //spin up a container at that port (returns a promise)
      return startStopContainers.spinUpContainer(user.port);
    }));

  }).then(function() {
    console.log('All containers started successfully');


  //Now wait until the containers are actually READY
  }).then(function() {

    return Q.all(users.map(function(user) {

      //This will ping the container until it gets the expected "ready" response
      //Will reject if the response never happens
      return communicateWithContainers.checkIfContainerIsReady(user.port);
    }));

  }).then(function() {
    console.log('All containers are ready!');


  //Now send each user's container the appropriate files for that user
  }).then(function() {

    return Q.all(users.map(function(user) {

      var pathToHeroBrain = secrets.rootDirectory + '/user_code/hero/' + user.githubHandle + '_hero.js';
      var pathToHelperFile = secrets.rootDirectory + '/user_code/helpers/' + user.githubHandle + '_helpers.js';

      //Sends the hero file, then the helper file
      return communicateWithContainers.postFile(user.port, heroFilePath, 'hero').then(function() {
        console.log('Successfully sent hero file to user ' + user.githubHandle);
        return communicateWithContainers.postFile(user.port, helperFilePath, 'helper').then(function() {
          console.log('Successfully sent helper file to user ' + user.githubHandle);
        });
      })

    }));

  }).then(function() {
    console.log('Successfully sent all files to all user containers');
    console.log('All containers are ready!');
  });
};

module.exports = prepareUserContainers;