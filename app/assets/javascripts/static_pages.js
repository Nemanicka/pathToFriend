var geosearch = angular.module( "geosearch", ['ngResource']  );

geosearch.controller("geosearchController", function($scope, $http, $timeout) {
      
    $scope.firstId = "";
    $scope.secondId = "";    
    $scope.total = [1];
    $scope.chain = []; 
    var userInfoJson = null;

    var horCount = 0;
    var verCount = 0;

    $scope.check = function() {
    }
    
    
    
    $scope.send = function() {
       if( $scope.firstId == "" )
       {
            console.log("firstId is empty");
            return;
       }
       if( $scope.secondId == "" )
       {
            console.log("firstId is empty");
            return;
       }

       var idJSON = { 
                    "firstId": $scope.firstId,
                    "secondId": $scope.secondId
                    };
                    
       var token = function(id) {         
            var el = document.getElementsByName("csrf-token")[0].content;
            return el;       
            // do something with el     };
       }()
       
       $http.defaults.headers.post = { 'X-CSRF-Token': token,  'skip_before_action': 'verify_authenticity_token',  'Content-Type': 'application/json', 'Accept': 'application/json' }
       $http.defaults.headers.get = { 'skip_before_action': 'verify_authenticity_token',  'Content-Type': 'application/json', 'Accept': 'application/json' }

       

       var res = $http.post('/id_json', idJSON);
       $scope.startStream();
    }

    $scope.startStream = function() {
        console.log("startStream");
        var source = new EventSource('/startStream');
        if(typeof(EventSource) !== "undefined") {
            console.log("created")
        } else {
            console.log("failed to create")
        }

        source.onopen = function(event)
        {
            console.log("opened");
        }

        source.onerror = function(event)
        {
            
            console.log("error");
            source.close();
            return;
        }
        source.onmessage = function(event) 
        {
            message = JSON.parse( event.data );
            if( message.addChain == true )
            {
                console.log("push to var");
                $scope.chain.push(horCount);
                console.log( $scope.chain.length );
                $scope.$apply();
                ++horCount;
            }
            console.log(message.addChain);
        }

    }
  
});

 
