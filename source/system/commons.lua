--[[ 
	----------Trophy Manager------------
	Create and organize your direct adrenaline bubbles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

color.loadpalette()

flag_delete_db = false

if files.exists("modules/kernel.skprx") then
	if os.requirek("modules/kernel.skprx")==1 then __kernel = true end
else
	if os.requirek("ux0:VitaShell/module/kernel.skprx")==1 then __kernel = true end
end

if files.exists("modules/user.suprx") then
	if os.requireu("modules/user.suprx")==1 then __user = true end
else
	if os.requireu("ux0:VitaShell/module/user.suprx")==1 then __user = true end
end

__PATH_LANG = "ux0:data/ONETROPHY/lang/"
__PATH_FONT = "ux0:data/ONETROPHY/font/"
files.mkdir(__PATH_LANG)
files.mkdir(__PATH_FONT)
__LANG = os.language()

dofile("lang/english_us.txt")

if not files.exists(__PATH_LANG.."english_us.txt") then
	files.copy("lang/english_us.txt",__PATH_LANG)
end

if files.exists(__PATH_LANG..__LANG..".txt") then
	dofile(__PATH_LANG..__LANG..".txt")
end

fnt = font.load(__PATH_FONT.."font.ttf") or font.load(__PATH_FONT.."font.pgf") or font.load(__PATH_FONT.."font.pvf")

if fnt then
	font.setdefault(fnt)
end

accept,cancel = "cross","circle"

if buttons.assign()==0 then
	accept,cancel = "circle","cross"
end

back = image.load("resources/background.png") 
img_trophies = image.load("resources/trophies.png",60,60)
buttonskey = image.load("resources/buttons.png",20,20)
buttonskey2 = image.load("resources/buttons2.png",30,20)

_SORT_L = { STRING_SORT_ID, STRING_SORT_UNLOCKED, STRING_SORT_HIDDEN }
_SORT_G = { STRING_SORT_GROUP, STRING_SORT_PROGRESS }
_SORT_T = { STRING_SORT_TITLE, STRING_SORT_PROGRESS }

ICONS_TROPHY = "ux0:user/00/trophy/conf/"
CONF_TROPHY  = "ur0:user/00/trophy/conf/"
DATA_TROPHY  = "ur0:user/00/trophy/data/"
TROP_TROPHY  = "ur0:user/00/trophy/data/sce_trop"
DB_TROPHY    = "ur0:user/00/trophy/db"

ARCHIVE_ROOT  = "ux0:data/ONETROPHY/archive/"
ARCHIVE_ICONS = ARCHIVE_ROOT.."icons/"
ARCHIVE_CONF  = ARCHIVE_ROOT.."conf/"
ARCHIVE_DATA  = ARCHIVE_ROOT.."data/"
ARCHIVE_INDEX = ARCHIVE_ROOT.."index.txt"

ACTIVE_TROPHY_LIMIT = 100

function create_archive_dirs()

	files.mkdir(ARCHIVE_ROOT)
	files.mkdir(ARCHIVE_ICONS)
	files.mkdir(ARCHIVE_CONF)
	files.mkdir(ARCHIVE_DATA)

end

function clean_index_field(value)

	if value == nil then
		return ""
	end

	value = tostring(value)
	value = string.gsub(value,"\t"," ")
	value = string.gsub(value,"\n"," ")
	value = string.gsub(value,"\r"," ")

	return value

end

function archive_index_remove(npcommid)

	if not files.exists(ARCHIVE_INDEX) then
		return
	end

	local entries = get_archive_index()
	local fp = io.open(ARCHIVE_INDEX,"w")

	if fp then

		for i=1,#entries do

			if entries[i].npcommid ~= npcommid then

				local e = entries[i]

				fp:write(
					clean_index_field(e.npcommid).."\t"..
					clean_index_field(e.title).."\t"..
					clean_index_field(e.details).."\t"..
					clean_index_field(e.total).."\t"..
					clean_index_field(e.platinum).."\t"..
					clean_index_field(e.gold).."\t"..
					clean_index_field(e.silver).."\t"..
					clean_index_field(e.bronze).."\t"..
					clean_index_field(e.group).."\t"..
					clean_index_field(e.progress).."\t"..
					clean_index_field(e.unlockP).."\t"..
					clean_index_field(e.unlockG).."\t"..
					clean_index_field(e.unlockS).."\t"..
					clean_index_field(e.unlockB).."\n"
				)

			end

		end

		fp:close()

	end

end

function archive_index_write_entry(obj)

	create_archive_dirs()

	local entries = get_archive_index()
	local found = false

	for i=1,#entries do

		if entries[i].npcommid == obj.npcommid then
			entries[i] = obj
			found = true
			break
		end

	end

	if not found then
		table.insert(entries,obj)
	end

	local fp = io.open(ARCHIVE_INDEX,"w")

	if fp then

		for i=1,#entries do

			local e = entries[i]

			fp:write(
				clean_index_field(e.npcommid).."\t"..
				clean_index_field(e.title).."\t"..
				clean_index_field(e.details).."\t"..
				clean_index_field(e.total).."\t"..
				clean_index_field(e.platinum).."\t"..
				clean_index_field(e.gold).."\t"..
				clean_index_field(e.silver).."\t"..
				clean_index_field(e.bronze).."\t"..
				clean_index_field(e.group).."\t"..
				clean_index_field(e.progress).."\t"..
				clean_index_field(e.unlockP).."\t"..
				clean_index_field(e.unlockG).."\t"..
				clean_index_field(e.unlockS).."\t"..
				clean_index_field(e.unlockB).."\n"
			)

		end

		fp:close()

	end

end

function get_archive_index()

	local list = {}

	if not files.exists(ARCHIVE_INDEX) then
		return list
	end

	local fp = io.open(ARCHIVE_INDEX,"r")

	if fp then

		for line in fp:lines() do

			if line ~= "" then

				local fields = {}

				for field in string.gmatch(line,"[^\t]+") do
					table.insert(fields,field)
				end

				local obj = {}

				obj.npcommid = fields[1] or ""
				obj.title = fields[2] or obj.npcommid
				obj.details = fields[3] or ""
				obj.total = tonumber(fields[4]) or 0
				obj.platinum = tonumber(fields[5]) or 0
				obj.gold = tonumber(fields[6]) or 0
				obj.silver = tonumber(fields[7]) or 0
				obj.bronze = tonumber(fields[8]) or 0
				obj.group = tonumber(fields[9]) or -1
				obj.progress = tonumber(fields[10]) or 0
				obj.unlockP = tonumber(fields[11]) or 0
				obj.unlockG = tonumber(fields[12]) or 0
				obj.unlockS = tonumber(fields[13]) or 0
				obj.unlockB = tonumber(fields[14]) or 0
				obj.unlockT = obj.unlockP + obj.unlockG + obj.unlockS + obj.unlockB
				obj.exist = false
				obj.del = false
				obj.hidden_archive = true

				if obj.npcommid ~= "" then
					table.insert(list,obj)
				end

			end

		end

		fp:close()

	end

	return list

end

function archive_trophy(obj)

	create_archive_dirs()

	local npcommid = obj.npcommid

	if files.exists(ARCHIVE_CONF..npcommid) or files.exists(ARCHIVE_DATA..npcommid) then
		return false
	end

	files.copy(ICONS_TROPHY..npcommid, ARCHIVE_ICONS)
	files.copy(CONF_TROPHY..npcommid, ARCHIVE_CONF)
	files.copy(DATA_TROPHY..npcommid, ARCHIVE_DATA)

	if files.exists(ARCHIVE_CONF..npcommid) and files.exists(ARCHIVE_DATA..npcommid) then

		archive_index_write_entry(obj)

		files.delete(ICONS_TROPHY..npcommid)
		files.delete(CONF_TROPHY..npcommid)
		files.delete(DATA_TROPHY..npcommid)

		return true

	end

	return false

end

function restore_trophy(obj)

	create_archive_dirs()

	local npcommid = obj.npcommid

	if files.exists(CONF_TROPHY..npcommid) or files.exists(DATA_TROPHY..npcommid) then
		return false
	end

	if not files.exists(ARCHIVE_CONF..npcommid) or not files.exists(ARCHIVE_DATA..npcommid) then
		return false
	end

	files.copy(ARCHIVE_ICONS..npcommid, ICONS_TROPHY)
	files.copy(ARCHIVE_CONF..npcommid, CONF_TROPHY)
	files.copy(ARCHIVE_DATA..npcommid, DATA_TROPHY)

	if files.exists(CONF_TROPHY..npcommid) and files.exists(DATA_TROPHY..npcommid) then

		files.delete(ARCHIVE_ICONS..npcommid)
		files.delete(ARCHIVE_CONF..npcommid)
		files.delete(ARCHIVE_DATA..npcommid)
		archive_index_remove(npcommid)

		return true

	end

	return false

end

function delete_archived_trophy(obj)

	local npcommid = obj.npcommid

	files.delete(ARCHIVE_ICONS..npcommid)
	files.delete(ARCHIVE_CONF..npcommid)
	files.delete(ARCHIVE_DATA..npcommid)
	archive_index_remove(npcommid)

	return true

end

function draw.offsetgradrect(x,y,sx,sy,c1,c2,c3,c4,offset)

	local sizey = sy/2

	draw.gradrect(x,y,sx,sizey + offset,c1,c2,c3,c4)
	draw.gradrect(x,y + sizey - offset,sx,sizey + offset,c3,c4,c1,c2)

end