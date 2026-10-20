--[[ 
	----------Trophy Manager------------
	Create and organize your direct adrenaline bubbles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

local trophyT = {}
local hiddenT = {}

function get_trophies()

	trophyT = trophy.info(__TITLE)

	if trophyT then
		for i=#trophyT,1,-1 do

			if trophyT[i].title == nil then

				table.remove(trophyT,i)

			elseif not files.exists(CONF_TROPHY..trophyT[i].npcommid) or not files.exists(DATA_TROPHY..trophyT[i].npcommid) then

				table.remove(trophyT,i)

			else

				trophyT[i].total = tonumber(trophyT[i].total) or 0
				trophyT[i].group = tonumber(trophyT[i].group) or -1
				trophyT[i].progress = tonumber(trophyT[i].progress) or 0
				trophyT[i].unlockT = tonumber(trophyT[i].unlockT) or 0

				trophyT[i].exist = false
				trophyT[i].del = false
				trophyT[i].ID = ""

				game.umount()
					buttons.homepopup(0)
						game.mount(DATA_TROPHY..trophyT[i].npcommid.."/")

						local app = nil

						local fp = io.open(DATA_TROPHY..trophyT[i].npcommid.."/TRPTITLE.DAT","r")
						if fp then
							fp:seek("set",0x290)
							app = fp:read(0x9)
							if app == "TROPHAXSE" then
								fp:seek("set",0x2D0)
								app = fp:read(0x9)
							end
							fp:close()
							if app then
								trophyT[i].ID = app
							end
						end

						trophyT[i].commsign = nil
						local fp = io.open(DATA_TROPHY..trophyT[i].npcommid.."/TRPTRANS.DAT","r")
						if fp then
							fp:seek("set",0x190)
							trophyT[i].commsign = fp:read(0xA0)
							fp:close()
						end

						if app and game.exists(app) then
							trophyT[i].exist = true
						end

					buttons.homepopup(1)
				game.umount()

			end

		end
	end

end

function get_hidden_trophies()

	hiddenT = get_archive_index()

	if hiddenT and #hiddenT > 0 then
		table.sort(hiddenT, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
	end

end

function refresh_active_list(scroll,maxim)

	get_trophies()

	if trophyT and #trophyT > 0 then
		table.sort(trophyT, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
	end

	scroll:set(trophyT,maxim)

	return trophyT

end

function refresh_hidden_list(scroll,maxim)

	get_hidden_trophies()
	scroll:set(hiddenT,maxim)

	return hiddenT

end

function trophies_title()

	local view_mode = 1

	get_trophies()
	get_hidden_trophies()

	if trophyT and #trophyT > 0 then
		table.sort(trophyT, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
	end

	local maxim,inter,d_scroll,t_scroll,delete,sort_T = 5,55,25,25,0,1
	local currentList = trophyT
	local scroll = newScroll(currentList,maxim)

	buttons.interval(12,5)

	while true do

		buttons.read()
		
		if flag_delete_db then buttons.homepopup(0) else buttons.homepopup(1) end
		
		if back then back:blit(0,0) end

		if img_trophies then
			img_trophies:blitsprite(560,0,0)
			img_trophies:blitsprite(630,0,1)
			img_trophies:blitsprite(700,0,2)
			img_trophies:blitsprite(770,0,3)
		end

		if view_mode == 1 then
			screen.print(25,35,"Trophy Manager - Active",1,color.white,color.black)
		else
			screen.print(25,35,"Trophy Manager - Hidden",1,color.white,color.black)
		end

		screen.print(480,12,"L/R Switch Active/Hidden",1,color.white,color.black,__ACENTER)

		if view_mode == 1 then
			screen.print(955,10,"("..scroll.maxim.."/"..ACTIVE_TROPHY_LIMIT..")",1,color.red,color.black, __ARIGHT)
		else
			screen.print(955,10,"("..scroll.maxim..")",1,color.red,color.black, __ARIGHT)
		end

		if scroll.maxim > 0 and currentList then

			local y=95

			for i=scroll.ini, scroll.lim do

				if i == scroll.sel then

					if scroll.maxim >= maxim then
						draw.offsetgradrect(20,y-3,810,60,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					else
						draw.offsetgradrect(5,y-3,825,60,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					end

					screen.print(560 + 30, 65, currentList[scroll.sel].platinum,1,color.white,color.black, __ACENTER)
					screen.print(630 + 30, 65, currentList[scroll.sel].gold,1,color.white,color.black, __ACENTER)
					screen.print(700 + 30, 65, currentList[scroll.sel].silver,1,color.white,color.black, __ACENTER)
					screen.print(770 + 30, 65, currentList[scroll.sel].bronze,1,color.white,color.black, __ACENTER)
					screen.print(955, 65, currentList[scroll.sel].total,1,color.white,color.black, __ARIGHT)

					if view_mode == 1 and not currentList[scroll.sel].exist then
						screen.print(950,460,(currentList[scroll.sel].ID or "").." "..STRINGS_GAME_NOT_INSTALLED,1.5,color.red:a(150),color.black, __ARIGHT)
					end

					if screen.textwidth(currentList[scroll.sel].details,1) > 945 then
						d_scroll = screen.print(d_scroll,520,currentList[scroll.sel].details,1,color.white,color.black, __SLEFT,920)
					else 
						screen.print(480,520,currentList[scroll.sel].details,1,color.white,color.black, __ACENTER)
					end

				end

				if scroll.maxim >= maxim then

					local ybar,h=93, (maxim*(inter + 15))-7
					draw.fillrect(5, ybar-2, 8, h, color.shine:a(50))

					local pos_height = math.max(h/scroll.maxim, maxim)
					draw.fillrect(5, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

				end

				if screen.textwidth(currentList[i].title,1) > 530 then
					t_scroll = screen.print(t_scroll,y,currentList[i].title,1,color.white,color.black,__SLEFT,520)
				else
					screen.print(25,y,currentList[i].title,1,color.white,color.black)
				end

				draw.fillrect(25, y + (inter/2), 200, 20, color.shine:a(80))
				draw.fillrect(25, y + (inter/2), math.map(currentList[i].progress, 0, 100, 0, 200), 20, color.green:a(80))
				draw.rect(25, y + (inter/2), 200, 20, color.white:a(200))
				screen.print(235, y + (inter/2), currentList[i].progress.."%",1,color.white,color.black)

				if currentList[i].group > 0 then
					screen.print(320, y + (inter/2), STRINGS_SUB_TROPHIES.." "..currentList[i].group,1,color.white,color.black)
				end

				if currentList[i].del then cgrad = color.red else cgrad = color.white:a(125) end

				draw.rect(560, y + (inter/2)-30, 270, 60, cgrad)
				screen.print(560 + 30, y + (inter/2)-5, currentList[i].unlockP,1,color.white,color.black, __ACENTER)
				screen.print(630 + 30, y + (inter/2)-5, currentList[i].unlockG,1,color.white,color.black, __ACENTER)
				screen.print(700 + 30, y + (inter/2)-5, currentList[i].unlockS,1,color.white,color.black, __ACENTER)
				screen.print(770 + 30, y + (inter/2)-5, currentList[i].unlockB,1,color.white,color.black, __ACENTER)

				if currentList[i].del then
					draw.offsetgradrect(5,y-3,825,60,color.red:a(60),color.red:a(75),0x0,0x0,10)
				end

				if not currentList[i].icon0 then

					if view_mode == 1 then
						currentList[i].icon0 = image.load(CONF_TROPHY..currentList[i].npcommid.."/ICON0.PNG")
					else
						currentList[i].icon0 = image.load(ARCHIVE_CONF..currentList[i].npcommid.."/ICON0.PNG")
					end

					if currentList[i].icon0 then
						currentList[i].icon0:resize(120,62)
						currentList[i].icon0:center()
					end

				else
					currentList[i].icon0:blit(955 - (currentList[i].icon0:getw()/2), y + (inter/2))
				end

				if buttonskey then buttonskey:blitsprite(10,437,2) end

				if view_mode == 1 then
					screen.print(40,440,"SQUARE Hide",1,color.white,color.black,__ALEFT)
				else
					screen.print(40,440,"SQUARE Unhide",1,color.white,color.black,__ALEFT)
				end

				if buttonskey2 then buttonskey2:blitsprite(5,460,1) end
				screen.print(40,462,"START Refresh/Update",1,color.white,color.black, __ALEFT)

				if buttonskey2 then buttonskey2:blitsprite(5,483,0) end
				screen.print(40,485,STRINGS_SORT.._SORT_T[sort_T],1,color.white,color.black,__ALEFT)

				y+=inter + 15

			end

		else

			if view_mode == 1 then
				screen.print(480,202,STRINGS_EMPTY,1.5,color.yellow,color.black,__ACENTER)
				screen.print(480,252,STRINGS_RELOAD_TROPHIES,1,color.white,color.black,__ACENTER)
			else
				screen.print(480,202,"No hidden trophies",1.5,color.yellow,color.black,__ACENTER)
				screen.print(480,252,"Press L/R to return to Active trophies",1,color.white,color.black,__ACENTER)
			end
			
			if view_mode == 1 and wlan.isconnected() then
				screen.print(480,352,STRINGS_TROPHY_WIFI_ON,1.5,color.yellow,color.black,__ACENTER)
			end

		end

		if buttonskey then buttonskey:blitsprite(940,483,1) end

		if view_mode == 1 then
			screen.print(935,485,"TRIANGLE Delete",1,color.white,color.black,__ARIGHT)
		else
			screen.print(935,485,"TRIANGLE Delete Hidden",1,color.white,color.black,__ARIGHT)
		end

		screen.flip()

		if buttons.released.l or buttons.released.r then

			if view_mode == 1 then
				view_mode = 2
				currentList = refresh_hidden_list(scroll,maxim)
			else
				view_mode = 1
				currentList = refresh_active_list(scroll,maxim)
			end

			delete = 0
			d_scroll,t_scroll = 25,25

		end

		if scroll.maxim > 0 and currentList then

			if (buttons.up or buttons.analogly<-60) then
				if scroll:up() then d_scroll,t_scroll = 25,25 end
			end

			if (buttons.down or buttons.analogly>60) then 
				if scroll:down() then d_scroll,t_scroll = 25,25 end
			end

			if buttons.square then

				if view_mode == 1 then

					if os.message("Hide this trophy title?",1) == 1 then

						if archive_trophy(currentList[scroll.sel]) then

							files.delete(TROP_TROPHY)
							flag_delete_db = true

							currentList[scroll.sel].icon0 = nil
							scroll:delete(currentList)

							get_hidden_trophies()

						else

							os.message("Archive failed. Trophy was not hidden. It may already exist in Hidden.")

						end

					end

				else

					if #trophyT >= ACTIVE_TROPHY_LIMIT then

						os.message("Cannot unhide. There are already 100 active trophy titles.")

					elseif files.exists(CONF_TROPHY..currentList[scroll.sel].npcommid) or files.exists(DATA_TROPHY..currentList[scroll.sel].npcommid) then

						os.message("Cannot unhide. This trophy already exists in the active list.")

					else

						if os.message("Unhide this trophy title?",1) == 1 then

							if restore_trophy(currentList[scroll.sel]) then

								files.delete(TROP_TROPHY)
								flag_delete_db = true

								currentList[scroll.sel].icon0 = nil
								scroll:delete(currentList)

								get_trophies()

							else

								os.message("Restore failed. Trophy was not unhidden.")

							end

						end

					end

				end

				delete = 0
				d_scroll,t_scroll = 25,25

			end

			if buttons.start then

				if flag_delete_db then

					if wlan.isconnected() then

						os.message(STRINGS_TROPHY_WIFI_ON)

					else

						files.delete(DB_TROPHY)
						os.delay(500)
						buttons.homepopup(0)
						os.uri("pstc:")

					end

				else

					if view_mode == 1 then
						currentList = refresh_active_list(scroll,maxim)
					else
						currentList = refresh_hidden_list(scroll,maxim)
					end

					delete = 0
					d_scroll,t_scroll = 25,25

				end

			end

			if buttons.select then

				if sort_T == 2 then
					sort_T = 1
					table.sort(currentList, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
				elseif sort_T == 1 then
					sort_T = 2
					table.sort(currentList, function (a,b) return (a.progress)>(b.progress) end)
				end

			end

			if view_mode == 1 and buttons[accept] then

				if currentList[scroll.sel].group > 0 then
					trophies_group(currentList[scroll.sel])
				else
					trophies_list(currentList[scroll.sel])
				end

			end

		end

		if buttons.triangle and scroll.maxim > 0 and currentList then

			if view_mode == 1 then

				if os.message(STRINGS_DELETE_QUESTION, 1) == 1 then

					files.delete(ICONS_TROPHY..currentList[scroll.sel].npcommid)
					files.delete(CONF_TROPHY..currentList[scroll.sel].npcommid)
					files.delete(DATA_TROPHY..currentList[scroll.sel].npcommid)

					currentList[scroll.sel].icon0 = nil
					scroll:delete(currentList)

					files.delete(TROP_TROPHY)
					flag_delete_db = true
					delete = 0

				end

			else

				if os.message("Delete this hidden trophy permanently?", 1) == 1 then

					delete_archived_trophy(currentList[scroll.sel])

					currentList[scroll.sel].icon0 = nil
					scroll:delete(currentList)

					delete = 0

				end

			end

		end

		if buttons[cancel] then

			if flag_delete_db then files.delete(DB_TROPHY) end

			buttons.homepopup(1)
			os.exit()

		end

	end

end