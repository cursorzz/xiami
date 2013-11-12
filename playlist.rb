require "sinatra"
require "haml"
require "./utils"

set :haml, :format => :html5

get '/:codes' do |code|
    @url_list = get_list code
    haml :list
end

post '/search' do
    q = params[:q]
    @albums = search q
    haml :search_result
end
