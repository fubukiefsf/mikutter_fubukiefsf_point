# -*- coding: utf-8 -*-

Plugin.create(:fubukiefsf_point) do
	launched_time = Time.now
	UserConfig[:fubukiefsf_point_to_system] ||= false
	UserConfig[:fubukishiPoint] ||= 10000
	UserConfig[:fubukishiTripPoint] ||= 3500
	UserConfig[:getFubukishiPoint] ||= 10000
	UserConfig[:enkunUnfavPoint] ||= 500
	fp_mes = ""
	
	
	on_appear do |mess|
		mess.each do |mes|
			if mes.message.to_s.include?("#ふぶき氏ポイント")
				if UserConfig[:fubukishiPoint] <= 0
					fp_mes = operateFubukishiPoint(0,"")
 				else
					fp_mes = operateFubukishiPoint(UserConfig[:fubukishiTripPoint],"use")
				end
				messageFubukishiPoint(fp_mes)
			end
		end
	end

	on_unfavorite do |service,user,message|
		if message.user.id == 159733526
			fp_mes = gainFubukishiPoint("enkun")
		end
		messageFubukishiPoint(fp_mes)
	end
	
	on_favorite do |service,user,message|
		if message.user.id == 51428532 
			fp_mes = gainFubukishiPoint("fubukishi_fav")
		elsif message.user.id == 15926668
			fp_mes = gainFubukishiPoint("toshi_a_fav")
		end
		messageFubukishiPoint(fp_mes)
	end

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
	
	Reserver.new("0:00"){
		UserConfig[:fubukishiPoint] += UserConfig[:getFubukishiPoint]
	}

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
				UserConfig[:fubukishiPoint] = 0
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

