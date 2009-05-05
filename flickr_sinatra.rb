require 'rubygems'
require 'sinatra'
require 'flickr'

# Setup the Flickr stuff
@@flickr = Flickr.new("flickr.cache", "f2949bc8f2e7d566279784478033e72a", "74b4e685176f27be")

not_found do
  erb :inde
end

get "/" do
  erb :index
end 

get "/view/:id" do |id|
  p "ID: " + id
  begin
    photos = @@flickr.photos.getSizes(params[:id])    
    if photos.sizes[:Original]
      original = photos.sizes[:Original].source
      redirect original
    elsif photos.sizes[:Large] 
      photos.sizes[:Large] 
      large = photos.sizes[:Large].source.gsub(/_l/, '_l_d')    
      redirect large        
    else
      erb :error
    end        
  rescue XMLRPC::FaultException
    erb :error    
  end
end

get "/download/:id" do |id|
  p "ID: " + id
  begin
    photos = @@flickr.photos.getSizes(params[:id])    
    if photos.sizes[:Original]
      original = photos.sizes[:Original].source.gsub(/_o/, '_o_d')
      redirect original
    elsif photos.sizes[:Large] 
      photos.sizes[:Large] 
      large = photos.sizes[:Large].source.gsub(/_l/, '_l_d')    
      redirect large        
    else
      erb :error
    end        
  rescue XMLRPC::FaultException
    erb :error    
  end
end

use_in_file_templates!

__END__

@@ index
<html>
<body>
<h1>nothing to see here!</h1>
</body>
</html>

@@ error
<html>
<body>
<h1>sorry, this image is unavailable.</h1>
</body>
</html>