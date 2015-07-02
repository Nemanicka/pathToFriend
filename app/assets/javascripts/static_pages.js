var geosearch = angular.module( "geosearch", ['ngResource']  );


geosearch.controller("geosearchController", function($scope, $http, $timeout) {
      
    $scope.user1 = {
                        "id": "",
                        "valid": false
                   }

    $scope.user2 = {
                        "id": "",
                        "valid": false
                   }
    $scope.chain = [ [] ];
    var userInfoJson = null;
        function callbackFunc(result) { 
            alert(result); 
        }

    var horCount = 0;
    var verCount = 0;
    var firstFilled = false;


    $scope.loading = false;

    $scope.check = function( user ) {

        $http.jsonp( 'https://api.vk.com/method/users.get', 
        {
            params: {
                callback: 'JSON_CALLBACK',
                user_ids: user.id
            }
        })
        .success( function(data) {
            if( data.response )
            {
                    console.log(data.response);
                if( data.response[0].deactivated )
                {
                    user.valid = false;
                    console.log("ne ok");
                }
                else
                {
                    user.valid = true;
                    console.log("ok");
                }
            }
            else
            {
                user.valid = false;
                console.log("ne ok");
            }
        })
        .error( function(data) {
            console.log("not  ok");
        });

        console.log("sent");
    }
    
    
    
    $scope.send = function() 
    {
       $scope.chain = [ [] ];
       firstFilled = false;

        if( !$scope.user1.valid || !$scope.user2.valid )
        {
           alert("sorry, but some id is not valid...");
           return; 
        }
    
       $scope.startStream();
    }

    $scope.validObject = false;
    
    $scope.startStream = function() {
        console.log("startStream");
        $scope.loading=true;
        var source = new EventSource('/id_json?firstId='+$scope.user1.id+'&secondId='+$scope.user2.id);
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
            $scope.loading=false;
            $scope.apply();
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

            if( message.status == "finished" )
            {
                console.log("finished ok");
                source.close();
                $scope.loading=false;
                $scope.$apply();
                return;
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

 
