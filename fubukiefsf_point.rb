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
		case message.user.id 
		when 159733526
			fp_mes = gainFubukishiPoint("enkun")
		when 111241653
			fp_mes = gainFubukishiPoint("k5342_enkun")
		when 260294821
			fp_mes = gainFubukishiPoint("a9_enkun")
		when 1216160988
			fp_mes = gainFubukishiPoint("firstspring_enkun")
		end
		messageFubukishiPoint(fp_mes)
	end
	
	on_favorite do |service,user,message|
		case message.user.id 
		when 51428532 
			fp_mes = gainFubukishiPoint("fubukishi_fav")
		when 15926668
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
		case mode
		when "enkun"
			return self.operateFubukishiPoint(4000,"gain")
		when "fubukishi_fav"
			return self.operateFubukishiPoint(200,"gain")
		when "toshi_a_fav"
			return self.operateFubukishiPoint(500,"gain")	
		when "k5342_enkun"
			return self.operateFubukishiPoint(1500,"gain")
		when "a9_enkun"
			return self.operateFubukishiPoint(2000,"gain")
		when "firstspring_enkun"
			return self.operateFubukishiPoint(1200,"gain")	
		end
	end
	 
	def operateFubukishiPoint(point,action)
		case action 
		when "gain"
			UserConfig[:fubukishiPoint] += point
		when "use"
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

