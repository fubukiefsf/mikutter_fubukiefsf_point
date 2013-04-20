# -*- coding: utf-8 -*-

Plugin.create(:fubukiefsf_point) do
	launched_time = Time.now
	UserConfig[:fubukiefsf_point_to_system] ||= false
	UserConfig[:fubukishiPoint] ||= 10000
	UserConfig[:fubukishiTripPoint] ||= 3500
	UserConfig[:getFubukishiPoint] ||= 10000
	UserConfig[:enkunUnfavPoint] ||= 500
	#ms = "";
	
	on_appear do |mess|
		mess.each do |mes|
			if mes.message.to_s.include?("#ふぶき氏ポイント")
				if UserConfig[:fubukishiPoint] <= 0
					ms = operateFubukishiPoint(0,"")
 				else
					ms = operateFubukishiPoint(UserConfig[:fubukishiPoint],"use")
				end
				messageFubukishiPoint(ms)
			end
		end
	end
	on_unfavorite do |service,user,message|
		if message.user.id == 159733526
			ms = gainFubukishiPoint("enkun")
		end
		messageFubukishiPoint(ms)
	end
	
	on_favorite do |service,user,message|
		if message.user.is_me?	
			if message.user.id == 51428532 
				ms = gainFubukishiPoint("fubukishi_fav")
			elsif message.user.id == 15926668
				ms = gainFubukishiPoint("toshi_a_fav")
			end
		end
		messageFubukishiPoint(ms)
	end

	#if(!ms)
	#end
	command(
		:fubukiefsf_point,
		name: "ふぶき氏ポイントを確認する",
		visible: false,
		condition: lambda{|opt| true},
		role: :window
	)do |opt|
		messageFubukishiPoint("You have #{UserConfig[:fubukishiPoint]} fubuki-shi points! Enjoy!")			
		Post.primary_service.update(:message => "ふぶき氏ポイントを#{UserConfig[:fubukishiPoint]}point持ってるよ" ,:system => UserConfig[:fubukiefsf_point_to_systemt] )
	end
	
	def repairFubukishiPoint
		Reserver.new("0:00"){
			UserConfig[:fubukishiPoint] += UserConfig[:getFubukishiPoint]
		}
	end

	def gainFubukishiPoint(mode)
		if mode == "enkun"
			return self.operateFubukishiPoint(1000,"gain")
		elsif mode == "fubukishi_fav"
			return self.operateFubukishiPoint(200,"gain")
		elsif mode == "toshi_a_fav"
			return self.operateFubukishiPoint(500,"gain")	
		end
	end
	 
	def operateFubukishiPoint(point,action)
		if action == "gain"
			UserConfig[:fubukishiPoint] += point
		elsif action == "use"
			if UserConfig[:fubukishiPoint] < UserConfig[:fubukishiTripPoint]
				UserConfig[:fubukishiPoint] -= UserConfig[:fubukishiPoint]
				return "全ポイント旅立ったよ"
			else
				UserConfig[:fubukishiPoint] -= point
			end
		else
			return " Too Late..."
		end	
		return " #{action} #{point} points fubuki-shi point."
	end
	
	def messageFubukishiPoint(mes)
		activity :system, mes
	end 
	
end

