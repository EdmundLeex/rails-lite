module ControllerMacro
	def helper_method(*methods)
		methods.each do |meth|
			Builder::Context.class_eval <<-ruby_eval
				def #{meth}(*args, &blk)
					@controller.send(%(#{meth}), *args, &blk)
				end
			ruby_eval
		end
	end
end