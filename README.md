# Testing Mojo::Promise in a Mojolicious Web App
This is an example repository I threw together while trying to get the hang of using Mojo::Promises and async/await 
in a Mojo webapp. Extracting the success and error values from the promise result seemed to be more 
difficult than I originally thought due to (I'm assuming) how the Mojo::IOLoop performs in a sub that handles 
rendering content.

All relevant testing code can be found in /lib/MojoPromiseTest/Controller/Example.pm

I have no idea if the way I went about doing this is considered best or even worst practices. It seems 
to work though. :) 
