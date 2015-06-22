//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

var geosearch = angular.module( "geosearch", ['ngResource']  ).
run( ['$rootScope', '$window',  
     function( $rootScope, $window  ) {
   
    $rootScope.user = {};    
    $window.fbAsyncInit = function() {     
    // Executed when the SDK is loaded      
    FB.init({         
    /*         The app id of the web app;        To register a new app visit Facebook App Dashboard        ( https://developers.facebook.com/apps/ )        */        
    appId: '1109608895722357',         
    /*         Adding a Channel File improves the performance         of the javascript SDK, by addressing issues         with cross-domain communication in certain browsers.        */        
    /*         Set if you want to check the authentication status        at the start up of the app        */        
    status: true,         /*         Enable cookies to allow the server to access         the session        */        
    cookie: true,         /* Parse XFBML */        
    xfbml: true,
    version: 'v2.3'  
    });      
    //sAuth.watchAuthenticationStatusChange();    
    };    
    // Are you familiar to IIFE ( http://bit.ly/iifewdb ) ?    
    (function(d){     
    // load the Facebook javascript SDK      
    var js,      
    id = 'facebook-jssdk',      
    ref = d.getElementsByTagName('script')[0];      
    if (d.getElementById(id)) { return; }      
    js = d.createElement('script');      
    js.id = id;      
    js.async = true;     
    js.src = "//connect.facebook.net/en_US/sdk.js";      
    ref.parentNode.insertBefore(js, ref);    
    }(document));  
}]); 


geosearch.controller("geosearchController", function($scope, $http, $timeout) {
    $scope.lal = 1;   
    $scope.firstId = ""    
    $scope.secondId = ""    


    $scope.change = function() {
        
    }

    $scope.check = function() {
        $scope.lal++;
    }
    
    
    userInfoJson = null;
    
    $scope.checkLoginState = function () {  
                                FB.getLoginStatus(function(response) 
                                {               
                                    statusChangeCallback(response);      
                                }); 
                             }
    
    $scope.logout =  function() {    
                        var _self = this;    
                            FB.logout(function(response) {      
                                 $scope.$apply(function() {         
                                    $scope.user = _self.user = {};       
                                 });     
                            }); 
                        }
    
    
    function statusChangeCallback(response) {          
        console.log('statusChangeCallback'); 
        console.log(response);      
            if (response.status === 'connected') {
            // Logged into your app and Facebook.     
                userInfoJson = response;
                //testAPI();
            } else if (response.status === 'not_authorized') {               
            // The person is logged into Facebook, but not your app.         
            document.getElementById('status').innerHTML = 'Please log ' +  'into this app.';         
            } else {          
            // The person is not logged into Facebook, so we're not sure if  
            // they are logged into this app or not.                     
            document.getElementById('status').innerHTML = 'Please log ' +  'into Facebook.';         
            } 
      }
    
    $scope.send = function() {
   /*    var idJSON = JSON.parse (
                    '{' +
                    '"firstId": "scopefirstId",' +
                    '"secondID": "scopesecondId"' + 
                    '}'
                    )*/
       var idJSON = { 
                    "firstId": $scope.firstId,
                    "secondID": $scope.secondId
                    };
                    
       var token = function(id) {         
            var el = document.getElementsByName("csrf-token")[0].content;
            return el;       
            // do something with el     };
       }()
       
//       alert(token);
//       if (userInfoJson == null)
//     {
//            console.log("not logged in");
//            $scope.checkLoginState();
//            return; 
//       }
       $http.defaults.headers.post = { 'X-CSRF-Token': token,  'skip_before_action': 'verify_authenticity_token',  'Content-Type': 'application/json', 'Accept': 'application/json' }
       $http.defaults.headers.get = { 'skip_before_action': 'verify_authenticity_token',  'Content-Type': 'application/json', 'Accept': 'application/json' }

       

       var res = $http.post('/id_json', idJSON);

    }

/*
    $scope.vkLogin = function() {
        var oauth = new XMLHttpRequest();
       // var tmp = window.open();
        var tmp = window.open('https://oauth.vk.com/authorize?client_id=2&redirect_uri=https://oauth.vk.com/blank.html&scope=12&display=page&response_type=token', 'login', 'height=200', 'width=200');
        var url = tmp.location.href;
        var params = url.split('#');
        alert(url);
    //    alert(params[1]);

        // window.open();
       // oauth.open('GET', 'https://oauth.vk.com/authorize?client_id=1&redirect_uri=https://oauth.vk.com/blank.html&scope=12&display=page&response_type=token', false);
       // oauth.setRequestHeader('Access-Control-Allow-Origin', '*');
//        oauth.send();
  //      alert(oauth.responseText);
   //     alert(oauth.getAllResponseHeaders);
    }
*/
            
});
