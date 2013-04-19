# -*- coding: utf-8 -*-

Plugin.create(:fubukiefsf_point) do
	launched_time = Time.now
	UserConfig[:fubukishiPoint] ||= 10000
	UserConfig[:fubukishiTripPoint] ||= 3500
	UserConfig[:getFubukishiPoint] ||= 10000
	UserConfig[:enkunUnfavPoint] ||= 500

	
	on_appear do |mess|
		mess.each do |mes|
			if mes.message.to_s.include?("#ふぶき氏ポイント")
				if UserConfig[:fubukishiPoint] <= 0
					operateFubukishiPoint(0,"")
				#elsif
 				else
					operateFubukishiPoint(UserConfig[:fubukishiPoint],"use")
				end
			end
		end
	end
	on_unfavorite do |service,user,message|
		if message.user.id == 159733526
			gainFubukishiPoint("enkun")
		end
	end
	
	on_favorite do |service,user,message|
		if message.user.id == 51428532 
			gainFubukishiPoint("fubukishi_fav")
		elsif message.user.id == 15926668
			gainFubukishiPoint("toshi_a_fav")
		end
	end

	def gainFubukishiPoint(mode)
		if mode == "enkun"
			self.operateFubukishiPoint(1000,"gain")
		elsif mode == "fubukishi_fav"
			self.operateFubukishiPoint(200,"gain")
		elsif mode == "toshi_a_fav"
			self.operateFubukishiPoint(500,"gain")	
		end
	end
	 
	def operateFubukishiPoint(point,action)
		if action == "gain"
			UserConfig[:fubukishiPoint] += point
		elsif action == "use"
			if UserConfig[:fubukishiPoint] < UserConfig[:fubukishiTripPoint]
				activity :system, "ポイントが足りないよ"
				return
			else
				UserConfig[:fubukishiPoint] -= point
			end
		else
			activity :system, " Too Late..."
			return
		end	
		activity :system, " #{action} #{point} points fubuki-shi point."
	end
end

