=begin
        Main Program Code of the Controller-Block

N O T E:
    All necessary info contained in README.md
* * *
    params > Key Variable (by default > Sinatra)
                ==> Which contains received data > In Hash-Data type.
EXAMPLE:
    1) params   > Contain all received data
    "#{params}" > To display all recived data.

    2) params[:key_name]   > Contain certain received data
    "#{params[:key_name]}" > To display Value of the Key_Name.
=end

require 'sinatra'
require "../models/my_user_model.rb"

# Thus the erb :index Method > Will search files in the "app/views" Directory.
set :root, File.join(File.dirname(__FILE__), '..')  # Changes|Sets Parent-Directory for the current File > If it was 'controllers/app.rb' > Now it is 'app/app.rb'.
                                                    # This is necessary so that the erb Method can find the '/views' Directory > Where the Views-Components are contained.
                                                    # Since the erb Method > Automatically looks for a file in the 'parent-directory/' of the current file + adds the 'views/' Directory. The result of the path is 'parent-directory/views/some_file.erb' === 'app/views/some_file.erb'.

set :public_folder, '../../public'  # Thus, we have indicated where to look for the '/public' Directory.
                                    # Since by default it is indicated that the '/public' Directory and the '/views' Directory are located in the same common Directory.
set :port, 8090
# set :bind, '0.0.0.0'
enable :sessions # To use SESSIONS

post '/users' do # For Creating a New User.
    # p(params)
    if(params.empty?)
        message = "You didn't enter any data!"
    return message
    else
        user = User.new()
        result = user.create(params) # puts(params)   
            if(result[:value])
                message = result[:description]
            return message
            else
                message = result[:description]
            return message 
            end
    end    
end

get '/users' do # For Displaying All Users-Data > Except their password.
    users = User.new()
    @users = users.all
        if(@users == nil)
            @message = "Users not exist at this time!"
            erb :index
          # erb :"advertising-posts/advertising_1"  # For example: If we need to include another file advertising_1.erb > Which is stored in the '/advertising-posts' Sub-Directory.  
        else
            index = 0
            @users.collect do |user|
                @users[index] = user.except(:password) 
                index += 1
            end
            erb :index
        end
end

post '/sign_in' do # For Sign in to the system using: -email && -password.
    #"#{params[:email]}"
    users = User.new()
    users = users.all
        if(users == nil)
            message = "User with Email: #{params[:email]} && Password: #{params[:password]} > Not exist! Please create a user account first."
        return message
        else
            message = ""
            users.each do |user|
                if(user[:email] == params[:email] && user[:password] == params[:password])
                    # p(user[:id]);   # p(session[:user_id])
                    session[:user_id] = user[:id] # puts(ssession)

                    message = "Welcome #{user[:firstname]}!"          
                return message
                else
                    message = "User with Email: #{params[:email]} && Password: #{params[:password]} > Not exist!\nPlease check that you entered the correct data."
                end
            end
        return message
        end
end

put '/users' do # For Changing the User's password.
    if(session[:user_id])
        user = User.new()
        result = user.update(session[:user_id], :password, params[:password]) # p(session[:user_id])
            if(result[:value] == true)
                message = "Password updated successfully!\n"
            return message
            else
                message = result[:description]
            return message
            end
    else
        message = "You are not Authorized! Please Sign in first."
    return message
    end
end

delete '/sign_out' do # For Sign out from the system.
    if(session[:user_id])
        # p(session)
        if(session.clear.empty?) # session.clear > To Destroy Session
            message = "You have successfully logged out!"
        return message
        else
            message = "ERROR > You are not logged out! Please try again after a few minutes."
        return message
        end
    else
        message = "You are not Authorized!"
    return message
    end
end

delete '/users' do # For Sign out from the system && Destroying the current User. 
    if(session[:user_id])
        user = User.new()
        result = user.destroy(session[:user_id])
            if(result[:value] == true && session.clear.empty?)
                message = "You have successfully deleted your account!"
            return message
            else
                message = "#{result[:description]} Please try again after a few minutes."
            return message
            end
    else
        message = "You are not Authorized!"
    return message
    end
end