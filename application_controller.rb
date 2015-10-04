class ApplicationController < ControllerBase
	helper_method :current_user

	def login(user)
		session[:session_token] = user.reset_session_token!
		@current_user = user
	end

	def logout
		
	end

	def current_user
		# debugger
		@current_user || User.find_by(session_token: session[:session_token])
	end
end