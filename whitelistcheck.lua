RADIX=10^7;RADIX_LEN=math.floor(math.log10(RADIX))BigNum={}BigNum.mt={}function BigNum.new(a)local b={}setmetatable(b,BigNum.mt)BigNum.change(b,a)return b end;function BigNum.mt.sub(c,d)local e=BigNum.new()local f=BigNum.new(c)local g=BigNum.new(d)BigNum.sub(f,g,e)return e end;function BigNum.mt.add(c,d)local e=BigNum.new()local f=BigNum.new(c)local g=BigNum.new(d)BigNum.add(f,g,e)return e end;function BigNum.mt.mul(c,d)local e=BigNum.new()local f=BigNum.new(c)local g=BigNum.new(d)BigNum.mul(f,g,e)return e end;function BigNum.mt.div(c,d)local f={}local g={}local h=BigNum.new()local i=BigNum.new()f=BigNum.new(c)g=BigNum.new(d)BigNum.div(f,g,h,i)return h,i end;function BigNum.mt.tostring(k)local l=0;local j=0;local m=""local e=""if k==nil then return"nil"elseif k.len>0 then for l=k.len-2,0,-1 do for j=0,RADIX_LEN-string.len(k[l])-1 do e=e..'0'end;e=e..k[l]end;e=k[k.len-1]..e;if k.signal=='-'then e=k.signal..e end;return e else return""end end;function BigNum.mt.pow(c,d)local f=BigNum.new(c)local g=BigNum.new(d)return BigNum.pow(f,g)end;function BigNum.mt.eq(c,d)local f=BigNum.new(c)local g=BigNum.new(d)return BigNum.eq(f,g)end;function BigNum.mt.lt(c,d)local f=BigNum.new(c)local g=BigNum.new(d)return BigNum.lt(f,g)end;function BigNum.mt.le(c,d)local f=BigNum.new(c)local g=BigNum.new(d)return BigNum.le(f,g)end;function BigNum.mt.unm(a)local n=BigNum.new(a)if n.signal=='+'then n.signal='-'else n.signal='+'end;return n end;BigNum.mt.__metatable="hidden"BigNum.mt.__tostring=BigNum.mt.tostring;BigNum.mt.__add=BigNum.mt.add;BigNum.mt.__sub=BigNum.mt.sub;BigNum.mt.__mul=BigNum.mt.mul;BigNum.mt.__div=BigNum.mt.div;BigNum.mt.__pow=BigNum.mt.pow;BigNum.mt.__unm=BigNum.mt.unm;BigNum.mt.__eq=BigNum.mt.eq;BigNum.mt.__le=BigNum.mt.le;BigNum.mt.__lt=BigNum.mt.lt;setmetatable(BigNum.mt,{__index="inexistent field",__newindex="not available",__metatable="hidden"})function BigNum.add(f,g,h)local o=0;local l=0;local p=0;local q='+'local r=0;if f==nil or g==nil or h==nil then error("Function BigNum.add: parameter nil")elseif f.signal=='-'and g.signal=='+'then f.signal='+'BigNum.sub(g,f,h)if not rawequal(f,h)then f.signal='-'end;return 0 elseif f.signal=='+'and g.signal=='-'then g.signal='+'BigNum.sub(f,g,h)if not rawequal(g,h)then g.signal='-'end;return 0 elseif f.signal=='-'and g.signal=='-'then q='-'end;r=h.len;if f.len>g.len then o=f.len else o=g.len;f,g=g,f end;for l=0,o-1 do if g[l]~=nil then h[l]=f[l]+g[l]+p else h[l]=f[l]+p end;if h[l]>=RADIX then h[l]=h[l]-RADIX;p=1 else p=0 end end;if p==1 then h[o]=1 end;h.len=o+p;h.signal=q;for l=h.len,r do h[l]=nil end;return 0 end;function BigNum.sub(f,g,h)local o=0;local l=0;local p=0;local r=0;if f==nil or g==nil or h==nil then error("Function BigNum.sub: parameter nil")elseif f.signal=='-'and g.signal=='+'then f.signal='+'BigNum.add(f,g,h)h.signal='-'if not rawequal(f,h)then f.signal='-'end;return 0 elseif f.signal=='-'and g.signal=='-'then f.signal='+'g.signal='+'BigNum.sub(g,f,h)if not rawequal(f,h)then f.signal='-'end;if not rawequal(g,h)then g.signal='-'end;return 0 elseif f.signal=='+'and g.signal=='-'then g.signal='+'BigNum.add(f,g,h)if not rawequal(g,h)then g.signal='-'end;return 0 end;if BigNum.compareAbs(f,g)==2 then BigNum.sub(g,f,h)h.signal='-'return 0 else o=f.len end;r=h.len;h.len=0;for l=0,o-1 do if g[l]~=nil then h[l]=f[l]-g[l]-p else h[l]=f[l]-p end;if h[l]<0 then h[l]=RADIX+h[l]p=1 else p=0 end;if h[l]~=0 then h.len=l+1 end end;h.signal='+'if h.len==0 then h.len=1;h[0]=0 end;if p==1 then error("Error in function sub")end;for l=h.len,max(r,o-1)do h[l]=nil end;return 0 end;function BigNum.mul(f,g,h)local l=0;j=0;local e=BigNum.new()local s=0;local p=0;local t=h.len;if f==nil or g==nil or h==nil then error("Function BigNum.mul: parameter nil")elseif f.signal~=g.signal then BigNum.mul(f,-g,h)h.signal='-'return 0 end;h.len=f.len+g.len;for l=1,h.len do h[l-1]=0 end;for l=h.len,t do h[l]=nil end;for l=0,f.len-1 do for j=0,g.len-1 do p=f[l]*g[j]+p;p=p+h[l+j]h[l+j]=math.fmod(p,RADIX)s=h[l+j]p=math.floor(p/RADIX)end;if p~=0 then h[l+g.len]=p end;p=0 end;for l=h.len-1,1,-1 do if h[l]~=nil and h[l]~=0 then break else h[l]=nil end;h.len=h.len-1 end;return 0 end;function BigNum.div(f,g,h,i)local e=BigNum.new()local s=BigNum.new()local u=BigNum.new("1")local v=BigNum.new("0")if BigNum.compareAbs(g,v)==0 then error("Function BigNum.div: Division by zero")end;if f==nil or g==nil or h==nil or i==nil then error("Function BigNum.div: parameter nil")elseif f.signal=="+"and g.signal=="-"then g.signal="+"BigNum.div(f,g,h,i)g.signal="-"h.signal="-"return 0 elseif f.signal=="-"and g.signal=="+"then f.signal="+"BigNum.div(f,g,h,i)f.signal="-"if i<v then BigNum.add(h,u,h)BigNum.sub(g,i,i)end;h.signal="-"return 0 elseif f.signal=="-"and g.signal=="-"then f.signal="+"g.signal="+"BigNum.div(f,g,h,i)f.signal="-"if i<v then BigNum.add(h,u,h)BigNum.sub(g,i,i)end;g.signal="-"return 0 end;e.len=f.len-g.len-1;BigNum.change(h,"0")BigNum.change(i,"0")BigNum.copy(f,i)while BigNum.compareAbs(i,g)~=2 do if i[i.len-1]>=g[g.len-1]then BigNum.put(e,math.floor(i[i.len-1]/g[g.len-1]),i.len-g.len)e.len=i.len-g.len+1 else BigNum.put(e,math.floor((i[i.len-1]*RADIX+i[i.len-2])/g[g.len-1]),i.len-g.len-1)e.len=i.len-g.len end;if i.signal~=g.signal then e.signal="-"else e.signal="+"end;BigNum.add(e,h,h)e=e*g;BigNum.sub(i,e,i)end;if i.signal=='-'then decr(h)BigNum.add(g,i,i)end;return 0 end;function BigNum.pow(f,g)local w=BigNum.new(g)local x=BigNum.new(1)local y=BigNum.new(f)local v=BigNum.new("0")if g<v then error("Function BigNum.exp: domain error")elseif g==v then return x end;while 1 do if math.fmod(w[0],2)==0 then w=w/2 else w=w/2;x=y*x;if w==v then return x end end;y=y*y end end;BigNum.exp=BigNum.pow;function BigNum.gcd(f,g)local z={}local A={}local B={}local C={}local v={}v=BigNum.new("0")if f==v or g==v then return BigNum.new("1")end;z=BigNum.new(f)A=BigNum.new(g)z.signal='+'A.signal='+'B=BigNum.new()C=BigNum.new()while A>v do BigNum.div(z,A,B,C)z,A,C=A,C,z end;return z end;BigNum.mmc=BigNum.gcd;function BigNum.eq(f,g)if BigNum.compare(f,g)==0 then return true else return false end end;function BigNum.lt(f,g)if BigNum.compare(f,g)==2 then return true else return false end end;function BigNum.le(f,g)local e=-1;e=BigNum.compare(f,g)if e==0 or e==2 then return true else return false end end;function BigNum.compareAbs(f,g)if f==nil or g==nil then error("Function compare: parameter nil")elseif f.len>g.len then return 1 elseif f.len<g.len then return 2 else local l;for l=f.len-1,0,-1 do if f[l]>g[l]then return 1 elseif f[l]<g[l]then return 2 end end end;return 0 end;function BigNum.compare(f,g)local q=0;if f==nil or g==nil then error("Funtion BigNum.compare: parameter nil")elseif f.signal=='+'and g.signal=='-'then return 1 elseif f.signal=='-'and g.signal=='+'then return 2 elseif f.signal=='-'and g.signal=='-'then q=1 end;if f.len>g.len then return 1+q elseif f.len<g.len then return 2-q else local l;for l=f.len-1,0,-1 do if f[l]>g[l]then return 1+q elseif f[l]<g[l]then return 2-q end end end;return 0 end;function BigNum.copy(f,g)if f~=nil and g~=nil then local l;for l=0,f.len-1 do g[l]=f[l]end;g.len=f.len else error("Function BigNum.copy: parameter nil")end end;function BigNum.change(f,a)local j=0;local D=0;local a=a;local E;local t=0;if f==nil then error("BigNum.change: parameter nil")elseif type(f)~="table"then error("BigNum.change: parameter error, type unexpected")elseif a==nil then f.len=1;f[0]=0;f.signal="+"elseif type(a)=="table"and a.len~=nil then for l=0,a.len do f[l]=a[l]end;if a.signal~='-'and a.signal~='+'then f.signal='+'else f.signal=a.signal end;t=f.len;f.len=a.len elseif type(a)=="string"or type(a)=="number"then if string.sub(a,1,1)=='+'or string.sub(a,1,1)=='-'then f.signal=string.sub(a,1,1)a=string.sub(a,2)else f.signal='+'end;a=string.gsub(a," ","")local F=string.find(a,"e")if F~=nil then a=string.gsub(a,"%.","")local G=string.sub(a,F+1)G=tonumber(G)if G~=nil and G>0 then G=tonumber(G)else error("Function BigNum.change: string is not a valid number")end;a=string.sub(a,1,F-2)for l=string.len(a),G do a=a.."0"end else F=string.find(a,"%.")if F~=nil then a=string.sub(a,1,F-1)end end;E=string.len(a)t=f.len;if E>RADIX_LEN then local H=E-math.floor(E/RADIX_LEN)*RADIX_LEN;for l=1,E-H,RADIX_LEN do f[j]=tonumber(string.sub(a,-(l+RADIX_LEN-1),-l))if f[j]==nil then error("Function BigNum.change: string is not a valid number")f.len=0;return 1 end;j=j+1;D=D+1 end;if H~=0 then f[j]=tonumber(string.sub(a,1,H))f.len=D+1 else f.len=D end;for l=f.len-1,1,-1 do if f[l]==0 then f[l]=nil;f.len=f.len-1 else break end end else f[j]=tonumber(a)f.len=1 end else error("Function BigNum.change: parameter error, type unexpected")end;if t~=nil then for l=f.len,t do f[l]=nil end end;return 0 end;function BigNum.put(k,I,J)if k==nil then error("Function BigNum.put: parameter nil")end;local l=0;for l=0,J-1 do k[l]=0 end;k[J]=I;for l=J+1,k.len do k[l]=nil end;k.len=J;return 0 end;function printraw(k)local l=0;if k==nil then error("Function printraw: parameter nil")end;while 1==1 do if k[l]==nil then io.write(' len '..k.len)if l~=k.len then io.write(' ERRO!!!!!!!!')end;io.write("\n")return 0 end;io.write('r'..k[l])l=l+1 end end;function max(K,L)if K>L then return K else return L end end;function decr(f)local e={}e=BigNum.new("1")BigNum.sub(f,e,f)return 0 end

local keys = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nicelion12345678910/Protected/main/keys.lua", true))()

local e = BigNum.new(keys.e)
local n = BigNum.new(keys.n)
local d = BigNum.new("4853")

local function modulo(a,b)
	if BigNum.lt(a,BigNum.new(0)) then
		local sub = BigNum.new()
		BigNum.sub(a,BigNum.new(0.5),sub)
		BigNum.change(a,sub)
		local add = BigNum.new()
		BigNum.add(b,a,add)
		BigNum.change(a,add)
	end

	local rem = BigNum.new()
	local div = BigNum.new()
	BigNum.div(a,b,div,rem)
	local mul = BigNum.new()
	BigNum.mul(div,b,mul)
	local sub = BigNum.new()
	BigNum.sub(a,mul,sub)

	return sub
end

local function encrypt(m)
	local pow = BigNum.pow(BigNum.new(m),BigNum.new(e))
	return modulo(pow,BigNum.new(n))
end

local function decrypt(c)
	local pow = BigNum.pow(BigNum.new(c),BigNum.new(d))
	return modulo(pow,BigNum.new(n))
end

local charToNum = {
	["a"] = "10",
	["b"] = "11",
	["c"] = "12",
	["d"] = "13",
	["e"] = "14",
	["f"] = "15",
	["g"] = "16",
	["h"] = "17",
	["i"] = "18",
	["j"] = "19",
	["k"] = "20",
	["l"] = "21",
	["m"] = "22",
	["n"] = "23",
	["o"] = "24",
	["p"] = "25",
	["q"] = "26",
	["r"] = "27",
	["s"] = "28",
	["t"] = "29",
	["u"] = "30",
	["v"] = "31",
	["w"] = "32",
	["x"] = "33",
	["y"] = "34",
	["z"] = "35",
	["A"] = "36",
	["B"] = "37",
	["C"] = "38",
	["D"] = "39",
	["E"] = "40",
	["F"] = "41",
	["G"] = "42",
	["H"] = "43",
	["I"] = "44",
	["J"] = "45",
	["K"] = "46",
	["L"] = "47",
	["M"] = "48",
	["N"] = "49",
	["O"] = "50",
	["P"] = "51",
	["Q"] = "52",
	["R"] = "53",
	["S"] = "54",
	["T"] = "55",
	["U"] = "56",
	["V"] = "57",
	["W"] = "58",
	["X"] = "59",
	["Y"] = "60",
	["Z"] = "61",
	["1"] = "62",
	["2"] = "63",
	["3"] = "64",
	["4"] = "65",
	["5"] = "66",
	["6"] = "67",
	["7"] = "68",
	["8"] = "69",
	["9"] = "70",
	["0"] = "71"
}
local numToChar = {
	["10"] = "a",
	["11"] = "b",
	["12"] = "c",
	["13"] = "d",
	["14"] = "e",
	["15"] = "f",
	["16"] = "g",
	["17"] = "h",
	["18"] = "i",
	["19"] = "j",
	["20"] = "k",
	["21"] = "l",
	["22"] = "m",
	["23"] = "n",
	["24"] = "o",
	["25"] = "p",
	["26"] = "q",
	["27"] = "r",
	["28"] = "s",
	["29"] = "t",
	["30"] = "u",
	["31"] = "v",
	["32"] = "w",
	["33"] = "q",
	["34"] = "y",
	["35"] = "z",
	["36"] = "A",
	["37"] = "B",
	["38"] = "C",
	["39"] = "D",
	["40"] = "E",
	["41"] = "F",
	["42"] = "G",
	["43"] = "H",
	["44"] = "I",
	["45"] = "J",
	["46"] = "K",
	["47"] = "L",
	["48"] = "M",
	["49"] = "N",
	["50"] = "O",
	["51"] = "P",
	["52"] = "Q",
	["53"] = "R",
	["54"] = "S",
	["55"] = "T",
	["56"] = "U",
	["57"] = "V",
	["58"] = "W",
	["59"] = "X",
	["60"] = "Y",
	["61"] = "Z",
	["62"] = "1",
	["63"] = "2",
	["64"] = "3",
	["65"] = "4",
	["66"] = "5",
	["67"] = "6",
	["68"] = "7",
	["69"] = "8",
	["70"] = "9",
	["71"] = "0"
}

local function encryptString(str)
	local encryptedString = ""
	for i=1,#str do
		print("Encrypting",(i/#str)*100 .."%")
		local char = str:sub(i,i)
		local num = charToNum[char]
		local encryptedNum = tostring(encrypt(num))
		encryptedString = encryptedString..encryptedNum:sub(1,#encryptedNum-2).." "
	end
	return encryptedString
end

local function decryptString(str)
	local decryptedString = ""
	local currentNum = ""
	for i=1,#str,1 do
		print("Decrypting",(i/#str)*100 .."%")
	
		local char = str:sub(i,i)
		
		if char == " " then
			local decryptedNum = tostring(decrypt(tonumber(currentNum)))
			decryptedNum = decryptedNum:sub(1,#decryptedNum-2)
			
			local decryptedChar = numToChar[decryptedNum]
			
			decryptedString = decryptedString..decryptedChar
		
			currentNum = ""
		else
			currentNum = currentNum..char
		end
	end
	return decryptedString
end

local localPlayer = game:GetService("Players").LocalPlayer

local accounts = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nicelion12345678910/Protected/main/accounts.lua", true))()
local whitelisted = false

if localPlayer:IsFriendsWith(2663217236) then
	local account = accounts[localPlayer.UserId]

	print("INPUT",_G.password)
	print("ENCRYPTED",account.password)

	if _G.password == decryptString(account.password) then
		whitelisted = true
	end
end

return whitelisted
