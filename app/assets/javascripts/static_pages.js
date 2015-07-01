var geosearch = angular.module( "geosearch", ['ngResource']  );

geosearch.controller("geosearchController", function($scope, $http, $timeout) {
      
    $scope.firstId = "";
    $scope.secondId = "";    
    $scope.chain = [ [] ]; 
    var userInfoJson = null;

    var horCount = 0;
    var verCount = 0;
    var firstFilled = false;

    $scope.check = function() {
    }
    
    
    
    $scope.send = function() 
    {
       $scope.chain = [ [] ];
       firstFilled = false;
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

   //    var idJSON = { 
   //                 "firstId": $scope.firstId,
   //                 "secondId": $scope.secondId
   //                 };
                    
   //    var token = function(id) {         
   //         var el = document.getElementsByName("csrf-token")[0].content;
   //         return el;       
   //    }()
       
//       $http.defaults.headers.post = { 'X-CSRF-Token': token,  'skip_before_action': 'verify_authenticity_token',  'Content-Type': 'application/json', 'Accept': 'application/json' }


//       var res = $http.post('/id_json', idJSON);
       $scope.startStream();
    }

    $scope.validObject = false;
    
    $scope.startStream = function() {
        console.log("startStream");
        var source = new EventSource('/id_json?firstId='+$scope.firstId+'&secondId='+$scope.secondId);
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
                $scope.chain[0].push(horCount);
                console.log( $scope.chain.length );
                $scope.$apply();
                ++horCount;
            }
            if( message.chain != undefined )
            {
                if( message.chain.length - 2 != horCount )
                {
                    console.log( "error: wrong length of chaing" );
                    console.log( horCount );
                    console.log(  message.chain.length -2);
                }
                    message.chain.pop();
                    message.chain.shift();
                    if (!firstFilled)
                    {
                        $scope.chain[0] = angular.copy(message.chain);
                        firstFilled = true;
                    }
                    else
                    {
                        console.log("push new!");
                        $scope.chain.push( message.chain );
                    }
                    
                    $scope.validObject = true;
                    console.log($scope.chain.length);
            }
        
            $scope.$apply();
            console.log(event.data);
        }

    }
  
});

 
