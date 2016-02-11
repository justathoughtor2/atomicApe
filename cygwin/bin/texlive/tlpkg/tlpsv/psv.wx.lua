--[[----------------------------------------------------------------------------
-- PS_View -- previewing utility for Ghostscript interpreter
-- Authors: P. Strzelczyk, P. Pianowski. Created: 15.06.1993; Lua part 26.10.2007
-- Address: BOP s.c. Gen. T. Bora-Komorowskiego 24, 80-377 Gda\'nsk, Poland
--          bop@bop.com.pl
-- Copyright: (c) 2009 BOP s.c.
-- Licence:   GPL
-- Current version: 5.12; 07.10.2009
--
-- 4.95 -- first working version of Lua engine
-- 4.96 -- mouse interface added (and many other changes)
-- 4.97 -- file search, open dialog, first approach of refresh, and icons
-- 4.98 -- new callbacks added: CONSOLE, CONFIG, INFO, console is now always
--         available (maybe hidden), more file search changes
-- 5.00 -- files renamed, refresh added, all dialogs active
-- 5.01 -- `namespaces': gsobj, gswin, gsargs, gsstat  added, internal timer
--         functions rebuild, mouse pane and scroll functionality implemented
--         refresh/update functionality fully implemented
-- 5.02 -- erase_event neutralised, DSC events isolated, RETURN = next page
-- 5.03 -- first attempt of localisation, grids on separate `layer'
-- 5.04 -- DSC reading corrected, `layer' and updating image corrected
-- 5.05 -- post-Pingwinaria release, 'layer' and printing bug corrected
-- 5.06 -- BachoTeX release
-- 5.07 -- post BachoTeX release
-- 5.08 -- full-screen mode
-- 5.09 -- LaTeX/HTML help added
-- 5.10 -- bug in DSC reading corrected
-- 5.11 -- some changes to compatibility with GS 8.64, and builtin inits
-- 5.12 -- changes for Windows Vista and wxWidgets 2.8.10, TL2009 release
------------------------------------------------------------------------------]]

local PS_VIEW_NAME="PS_View"
local PS_VIEW_VERSION=5.12
local PS_VIEW_VERSION_STRING -- defined later, after locale loading
local PSV_DftGsPars = {"-dNOPAUSE","-dDELAYBIND","-dNOEPS"}

local frame, console = nil, nil

local gsobj={
  instancechecker = nil,
  gsdll = nil,
  config = nil,
  helpctrl = nil,
  locale = nil,
  ghostscript = nil,
  image = nil,
  gstimer = nil,
  dscthread = nil,
  dialog = nil,
  menu = nil,
  SBsty = {}, SBall = {},
  overlay = nil,
  bbmp = nil, obmp = nil,
}

local gswin={
  gswindow = nil,
  logwindow = nil,
  editwindow = nil,
  menuBar = nil,
  statusBar = nil,
  dialog = nil,
}

local gsargs = {
  args= {},      -- arguments to ghostscript (wihout paths)
  dllloc= "",    -- localisation of DLL (passed to wxGhostscript)
  libloc = "",   -- search path for Postscript files (passed to wxGhostscript,
                 -- mounted from gslib, libs and psvlib)
  fontloc = "",  -- search path for fonts (passed to wxGhostscript)
  libs= {},      -- list of paths setted by -i option
  gslib= "",     -- path to GS init files (from config file or discovered from dllloc)
  psvlib= "",    -- path to PS_View files (from config file or discovered from
                 -- paths in progs or path to this program -- arg[0])
  progs = {},    -- PostScript program to run during init (added at the end of args)
  cmd_pars = {}, -- default GS arguments (can be overriden by config file,
                 -- added at the begin of args)
  psf_dir = "",  -- directory with the curently opened file
  psf_name = "", -- name of the curently opened file
}
local psvpars = {
  language = "",
}
local gsstat = {
  refr_int = 0,
  refresh  = 0,
  update   = 0,
  working  = false,
  ready    = false,
  inoverlay   = false, drawoverlay = false,
  -- fullscreen  = false,
}

function MakeIcons()
  local psvimg_xpm = {
  "48 48 3 1",
  "@ c black",
  ". c yellow",
  "  c None",
  "                 @@@@@@                         ",
  "                 @....@@@                       ",
  "                 @.......@                      ",
  "                 @........@@                    ",
  "                 @..........@                   ",
  "                 @...........@                  ",
  "                 @............@                 ",
  "                @..............@                ",
  "                @...............@               ",
  "               @................@               ",
  "              @..................@              ",
  "             @....................@             ",
  "            @......................@            ",
  "           @........................@           ",
  "          @..........................@          ",
  "         @............................@@        ",
  "        @...............................@@      ",
  "       @..................................@@@@@@",
  "      @........................................@",
  "     @.........................................@",
  "    @......@@@@@@@@@....@@@@@..@@@@..@@@@@.....@",
  "   @.......@@@@@@@@@@..@@@@@@@.@@@@..@@@@@.....@",
  "  @........@@@@@@@@@@@.@@@..@@.@@@@..@@@@@.....@",
  "  @..........@@@...@@@.@@@@.....@@....@@@.....@ ",
  " @...........@@@....@@..@@@@@...@@...@@@......@ ",
  "@@...........@@@....@@....@@@@..@@@.@@@......@  ",
  "@............@@@...@@@.@@..@@@...@@@@@.......@  ",
  "@............@@@@@@@@..@@@@@@@...@@@@.......@   ",
  "@............@@@@@@@....@@@@@.....@@.......@    ",
  "@............@@@..........................@     ",
  "@@@@@@......@@@@@........................@      ",
  "      @@....@@@@@.......................@       ",
  "        @@..@@@@@......................@        ",
  "          @...........................@         ",
  "           @.........................@          ",
  "            @.......................@           ",
  "             @.....................@            ",
  "              @...................@             ",
  "               @.................@              ",
  "                @...............@               ",
  "                @...............@               ",
  "                 @.............@                ",
  "                  @............@                ",
  "                   @..........@                 ",
  "                    @@........@                 ",
  "                      @.......@                 ",
  "                       @@.....@                 ",
  "                         @@@@@@                 "
  };

  local psvimg_xpm32 = {
  "32 32 3 1",
  "@ c black",
  ". c yellow",
  "  c None",
  "           @@@@@                ",
  "           @....@@              ",
  "           @......@             ",
  "           @.......@            ",
  "          @.........@           ",
  "          @..........@          ",
  "         @............@         ",
  "        @..............@        ",
  "       @................@       ",
  "      @..................@      ",
  "     @....................@@    ",
  "    @.......................@@@@",
  "   @...........................@",
  "  @....@@@@@@...@@@@.@@@..@@@..@",
  " @.....@@@@@@@.@@..@.@@@..@@@..@",
  " @......@@..@@.@@@....@...@@...@",
  "@.......@@..@@..@@@@..@@.@@...@ ",
  "@.......@@.@@@.@...@@.@@@@...@  ",
  "@.......@@@@@..@@@@@@..@@...@   ",
  "@.......@@......@@@@...@@..@    ",
  "@@@....@@@@...............@     ",
  "   @@..@@@@..............@      ",
  "     @..................@       ",
  "      @@...............@        ",
  "        @.............@         ",
  "         @...........@          ",
  "          @..........@          ",
  "           @........@           ",
  "            @.......@           ",
  "             @......@           ",
  "              @@....@           ",
  "                @@@@@           "
  };

  local psvimg_xpm16 = {
  "16 16 3 1",
  "@ c black",
  ". c yellow",
  "  c None",
  "      @@@       ",
  "      @..@      ",
  "      @...@     ",
  "     @.....@    ",
  "    @.......@   ",
  "   @.........@  ",
  "  @...........@@",
  " @..@@@.@@@@.@.@",
  "@...@.@.@@.@.@.@",
  "@...@@@@@@.@@..@",
  "@@@.@.........@ ",
  "   @.........@  ",
  "    @.......@   ",
  "     @.....@    ",
  "      @...@     ",
  "       @@@@     "
  };

  local psvtxt_xpm = {unpack(psvimg_xpm)}
    psvtxt_xpm[3]=". c green"

  local psvtxt_xpm32 = {unpack(psvimg_xpm32)}
    psvtxt_xpm32[3]=". c green"

  local psvtxt_xpm16 = {unpack(psvimg_xpm16)}
    psvtxt_xpm16[3]=". c green"

  local bmpi,iconi,iconimg,icontxt

  iconi = wx.wxIcon()
  bmpi = wx.wxBitmap(psvimg_xpm)
    iconi:CopyFromBitmap(bmpi)
  iconimg = wx.wxIconBundle(iconi)
  bmpi = wx.wxBitmap(psvimg_xpm32)
    iconi:CopyFromBitmap(bmpi)
    iconimg:AddIcon(iconi)
  bmpi = wx.wxBitmap(psvimg_xpm16)
    iconi:CopyFromBitmap(bmpi)
    iconimg:AddIcon(iconi)

  bmpi = wx.wxBitmap(psvtxt_xpm)
    iconi:CopyFromBitmap(bmpi)
  icontxt = wx.wxIconBundle(iconi)
  bmpi = wx.wxBitmap(psvtxt_xpm32)
    iconi:CopyFromBitmap(bmpi)
    icontxt:AddIcon(iconi)
  bmpi = wx.wxBitmap(psvtxt_xpm16)
    iconi:CopyFromBitmap(bmpi)
    icontxt:AddIcon(iconi)

  return iconimg,icontxt
end


function PrepareKeyNames()

  -- wxMOD-s should be defined in wxLua
  wx.wxMOD_NONE=0
  wx.wxMOD_ALT=1   wx.wxMOD_CONTROL=2
  wx.wxMOD_SHIFT=4 wx.wxMOD_META=8

  wx.wxMOD_MORE_THAN_SHIFT=wx.wxMOD_ALT+wx.wxMOD_META+wx.wxMOD_CONTROL

  mod_text={
    [wx.wxMOD_NONE]="NORM",
    [wx.wxMOD_SHIFT]="SHIFT",
    [wx.wxMOD_CONTROL]="CTRL",
    [wx.wxMOD_CONTROL+wx.wxMOD_SHIFT]="SHIFTCTRL",
    [wx.wxMOD_ALT]="ALT",
    [wx.wxMOD_ALT+wx.wxMOD_SHIFT]="SHIFTALT",
    [wx.wxMOD_ALT+wx.wxMOD_CONTROL]="CTRLALT",
    [wx.wxMOD_ALT+wx.wxMOD_CONTROL+wx.wxMOD_SHIFT]="SHIFTCTRLALT",
    --
    [wx.wxMOD_META]="META",
    [wx.wxMOD_SHIFT+wx.wxMOD_META]="SHIFTMETA",
    [wx.wxMOD_CONTROL+wx.wxMOD_META]="CTRLMETA",
    [wx.wxMOD_CONTROL+wx.wxMOD_SHIFT+wx.wxMOD_META]="SHIFTCTRLMETA",
    [wx.wxMOD_ALT+wx.wxMOD_META]="ALTMETA",
    [wx.wxMOD_ALT+wx.wxMOD_SHIFT+wx.wxMOD_META]="SHIFTALTMETA",
    [wx.wxMOD_ALT+wx.wxMOD_CONTROL+wx.wxMOD_META]="CTRLALTMETA",
    [wx.wxMOD_ALT+wx.wxMOD_CONTROL+wx.wxMOD_SHIFT+wx.wxMOD_META]="SHIFTCTRLALTMETA",
  }

  key_text={
    [wx.WXK_INSERT]="INS",
    [wx.WXK_DELETE]="DEL",
    [wx.WXK_HOME]="HOME",
    [wx.WXK_END]="END",
    [wx.WXK_PAGEUP]="PAGE_UP",
    [wx.WXK_PAGEDOWN]="PAGE_DOWN",
    [wx.WXK_UP]="UP_ARR",
    [wx.WXK_DOWN]="DOWN_ARR",
    [wx.WXK_LEFT]="LEFT_ARR",
    [wx.WXK_RIGHT]="RIGHT_ARR",
    [wx.WXK_TAB]="TAB",
    [wx.WXK_ESCAPE]="ESC",
    --
    [wx.WXK_NUMPAD_INSERT]="INS",
    [wx.WXK_NUMPAD_DELETE]="DEL",
    [wx.WXK_NUMPAD_HOME]="HOME",
    [wx.WXK_NUMPAD_END]="END",
    [wx.WXK_NUMPAD_PAGEUP]="PAGE_UP",
    [wx.WXK_NUMPAD_PAGEDOWN]="PAGE_DOWN",
    [wx.WXK_NUMPAD_UP]="UP_ARR",
    [wx.WXK_NUMPAD_DOWN]="DOWN_ARR",
    [wx.WXK_NUMPAD_LEFT]="LEFT_ARR",
    [wx.WXK_NUMPAD_RIGHT]="RIGHT_ARR",
    [wx.WXK_NUMPAD_DIVIDE]="DIVIDE",
    [wx.WXK_NUMPAD_MULTIPLY]="MULTIPLY",
    [wx.WXK_NUMPAD_SUBTRACT]="SUBSTRACT",
    [wx.WXK_NUMPAD_ADD]="ADD",
    [wx.WXK_NUMPAD_EQUAL]="EQUAL",
    [wx.WXK_NUMPAD_BEGIN]="BEGIN",
    --[wx.WXK_NUMPAD_DECIMAL]="",
    --[wx.WXK_NUMPAD_SEPARATOR]="",
  }
  for i = 1, 24 do s=string.format("F%d",i) key_text[wx["WXK_" .. s]]=s end
  for i = 0, 9  do s=string.format("%d",i) key_text[wx["WXK_NUMPAD" .. s]]=s end

  char_text={
    [wx.WXK_NUMPAD_ENTER]="RETURN",
    [wx.WXK_RETURN]="RETURN",
    [wx.WXK_BACK]="BACK",
    [string.byte("`")]="GRAVE",
    [string.byte("-")]="MINUS",
    [string.byte("=")]="EQUAL",
    [string.byte("\\")]="BACKSLASH",
    [string.byte("[")]="BRACKETL",
    [string.byte("]")]="BRACKETR",
    [string.byte(";")]="SEMICOLON",
    [string.byte("'")]="ACUTE",
    [string.byte(",")]="COMMA",
    [string.byte(".")]="PERIOD",
    [string.byte("/")]="SLASH",
  }
  for i = string.byte("0"), string.byte("9") do
    char_text[i]=string.format("%c",i) end
  for i = string.byte("A"), string.byte("Z") do
  char_text[i]=string.format("%c",i) end

  char_shift_text={
    [string.byte(">")]="GREATER",
    [string.byte("<")]="LESS",
  }
end

function MakeQueue()
  return { b=0; t=0;
    add = function(s,str) s.t=s.t+1 s[s.t]=str end;
    insert = function(s,str)
      for i=1,s.t do s[i+1]=s[i] end
      s[1]=str s.t=s.t+1
    end;
    get = function(s)
      s.b=s.b+1 local str=s[s.b]
      if s.b>=s.t then s.b=0 s.t=0 end
      return str
    end;
    getMax = function(s)
      s.b=s.b+1 local str=s[s.b]
      while s.b<s.t and str:len()<30000 do
        s.b=s.b+1 str=str.."\n"..s[s.b]
      end	
      if s.b>=s.t then s.b=0 s.t=0 end
      return str
    end;
    peek = function(s) return s[s.b+1] end;
    isEmpty = function(s) return s.t==0 end;
  }
end

function MakeIdList()
  return {
    newId = function(s,str)
      local id="ID_"..str
      s[id]=wx.wxNewId()
--or      if not s[id] then s[id]=wx.wxNewId() end
      s["NAM_"..s[id]]=str
      return s[id]
    end;
    newObj = function(s,str,creator)
      local id="OBJ_"..str
      s[id]=creator
--or      if not s[id] then s[id]=creator end
      return s[id]
    end;
    newCtrl = function(s,id,type)
      table.insert(s,{id=id,type=type})
    end;
    getId = function(s,str) return s["ID_"..str] end;
    getObj = function(s,str) return s["OBJ_"..str] end;
    getName = function(s,id) return s["NAM_"..id] end;
  }
end

local iconimg, icontxt = MakeIcons()
gsobj.menu = MakeIdList()
local RunPScode, RunDSCcode = MakeQueue(), MakeQueue()
local StdInCode = MakeQueue()

local Mouse = { Cnone=0, Czoom=1, Cpane=2, Cmeasure=3, Cscroll=4,
  Cendmeas=5, Cdblclick=6;
  cursorHand=wx.wxCursor(wx.wxCURSOR_HAND),
  cursorMag=wx.wxCursor(wx.wxCURSOR_MAGNIFIER),
  cursorCross=wx.wxCursor(wx.wxCURSOR_BLANK); -- wxCURSOR_CROSS, wx.wxCURSOR_BULLSEYE
  penRed=wx.wxPen("RED",1,wx.wxSOLID), penBlue=wx.wxPen("BLUE",1,wx.wxSOLID);
  bx=0, by=0, ex=0, ey=0, scroln=0, CMD=0, mod=0, timer=0,}

local Dobject = { n=0, id={},
  Oline=1, Orect=2, Ocros=3,  }
  Dobject.pens={ [-1] = wx.wxTRANSPARENT_PEN, [0] =
    wx.wxBLACK_PEN, wx.wxPen("BLUE",1,wx.wxSOLID),
    wx.wxGREEN_PEN, wx.wxCYAN_PEN,
    wx.wxRED_PEN,   wx.wxPen("MAGENTA",1,wx.wxSOLID),
    wx.wxPen("YELLOW",1,wx.wxSOLID), wx.wxWHITE_PEN,
    wx.wxPen("BLACK",3,wx.wxSOLID), wx.wxPen("BLUE",3,wx.wxSOLID),
    wx.wxPen("GREEN",3,wx.wxSOLID), wx.wxPen("CYAN",3,wx.wxSOLID),
    wx.wxPen("RED",3,wx.wxSOLID),   wx.wxPen("MAGENTA",3,wx.wxSOLID),
    wx.wxPen("YELLOW",3,wx.wxSOLID), wx.wxPen("WHITE",3,wx.wxSOLID),
  }
  Dobject.brushess={ [-1] = wx.wxTRANSPARENT_BRUSH, [0] =
    wxBLACK_BRUSH, wx.wxBLUE_BRUSH,
    wxGREEN_BRUSH, wxCYAN_BRUSH,
    wxRED_BRUSH,   wx.wxBrush("MAGENTA",wx.wxSOLID),
    wx.wxBrush("YELLOW",wx.wxSOLID), wxWHITE_BRUSH,
    wxGREY_BRUSH
  }


local v_quiet,v_normal,v_verbose=2,6,10
local verbose=v_normal

function print_debug(...)
  if verbose>v_normal then print(...) end
end

function print_message(...)
  if verbose>v_quiet then print(...) end
end

function SendEventCommand (c,s,...)
  RunPScode:add(string.format(s,...) .. " /" .. c .. " EVENTCOMMAND")
end

function SendMenuCommand (m,s)
  RunInputString()
  RunPScode:add("/" .. m .. " /" .. s .. " MENUCOMMAND")
end

function SendKeyCommand (k,s)
  RunInputString()
  RunPScode:add("/" .. k .. " /" .. s .. " KEYCOMMAND")
end

function SendMouseCommand (xa,ya,xb,yb,c,s)
  RunPScode:add(string.format("%d %d %d %d /%s /%s MOUSECOMMAND",xa,ya,xb,yb,c,s))
end

function SendMouseCommandWithStatus(mouse,cmd)
  SendMouseCommand (mouse.bx,mouse.by,mouse.ex,mouse.ey,cmd,mod_text[mouse.mod])
end

function SendDSCEventCommand (c,s,...)
  RunDSCcode:add(string.format(s,...) .. " /" .. c .. " EVENTCOMMAND")
end

function SendDSCComment(comm,begc,endc)
--  comm=comm:gsub("[\128-\255]","#")
  comm=comm:gsub("([\\%(%)])","\\%1")
  SendDSCEventCommand ("DSCCOMMENT","(%s) %d %d",comm,begc,endc)
end

function CallPSVhook (str)
  local b=str:find(": ")
  local c,l=str:sub(1,b-1),str:sub(b+2,-1)
  local f,s=l:sub(1,1),l:sub(2,2)
  local p={} for w in l:gmatch("{([^}]*)}") do table.insert(p,w) end
  print_debug(_T("PSVhook>>") .. str .."\n")
  if c=="FINDDSC" then
    StartDSCthread(p[1])
  elseif c=="DIALOG" then
    MakeFileDialogBox(f,p[1],p[2],p[3],p[4])
  elseif c=="DLGBOX" then
    MakeDialogBox(f,p[1],p[2],p[3],p[4])
  elseif c=="MESSAGEBOX" then
    MakeMessageBox(f,p[1])
  elseif c=="MENU" then
     MakeMenu(f,s,p[1],p[2],p[3])
  elseif c=="STATUS" then
     MakeStatusLine(f,s,p[1],p[2])
  elseif c=="REFRESH" then
     MakeRefreshEvent(p[1])
  elseif c=="SIZE" then
     MakeResizeEvent(f,s,p[1],p[2])
  elseif c=="DRAW" then
      DrawObjectEvent(f,s,p[1],p[2],p[3])
  elseif c=="HOOK" then
    -- reserved entry for debugging
  elseif c=="CONFIG" then
    MakeConfigFile(f,p[1],p[2],p[3])
  elseif c=="CONSOLE" then
    MakeConsole(f,p[1])
  elseif c=="HELP" then
    MakeHelpWindow(f,p[1])
  elseif c=="INFO" then
    SendInfoEvent()
  elseif c=="LOCALE" then
    SendLocaleEvent(f,p[1])
  elseif c=="LUA" then
    RunLuaCode(f,p[1])
  else
    error(_T("Unrecognized !PSV callback: ") .. str)
  end
end

function MakeRefreshEvent(fname)
  SetPSFile(PSFName(fname))
end

function MakeConfigFile(l,a,b,c)
  if gsobj.config then
    gsobj.config:SetPath("/" .. a)
    if l=="S" then
      gsobj.config:Write(b,c)
    elseif l=="G" then
      local _,r=gsobj.config:Read(b,c)
      if not _ then r=c end
      local n=tonumber(r) if not n then n=0 end
      SendEventCommand ("CONFIG","(%s) %d /%s",r,n,a.."_"..b)
    end
  end
end

function MakeConsole(l,a)
  if not console then
    -- it is now not used -- console can be hidden but always is defined
    if l=="S" then
      local wtitle=PS_VIEW_NAME .. _T(" Console")
      if gsargs.psf_name~="" then wtitle=gsargs.psf_name .. " -- " .. wtitle end
      console = wx.wxFrame( wx.NULL, wx.wxID_ANY, wtitle,
        wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDEFAULT_FRAME_STYLE)
      gswin.logwindow = wx.wxTextCtrl(console, wx.wxID_ANY, "",
        wx.wxDefaultPosition, wx.wxDefaultSize,
        wx.wxTE_MULTILINE + wx.wxTE_READONLY + wx.wxTE_RICH)
      console:Connect(wx.wxEVT_CLOSE_WINDOW, function (event) console:Hide() end)
      InitializeConsole()
      ConfigRestoreFramePosition(console, "ConsoleWindow")
      console:SetIcons(icontxt)
      function print(...)
        local str=""
        for i,v in ipairs{...} do str=str..tostring(v) end
        gswin.logwindow:AppendText(str)
      end
      console:Show()
    end
  elseif l=="S" then
    console:Show()
    console:Iconize(false)
  elseif l=="H" then
    console:Hide()
  elseif l=="P" then
    gswin.logwindow:AppendText(a)
  elseif l=="A" then
    gswin.editwindow:WriteText(a)
  end
end

function MakeHelpWindow(l,a)
  if l=="I" then
    gsobj.helpctrl=wx.wxHtmlHelpController(wx.wxHF_DEFAULT_STYLE,frame)
    gsobj.helpctrl:UseConfig(gsobj.config,"HelpControler")
    gsobj.helpctrl:SetTitleFormat(PS_VIEW_NAME .. _T(" Help -- %s"))
    local fname=wx.wxFileName(arg[0]):GetPath(wx.wxPATH_GET_VOLUME)
      fname=wx.wxFileName(fname,a)
    gsobj.helpctrl:AddBook(fname,false)
  elseif l=="S" then
    gsobj.helpctrl:DisplayContents()
  elseif l=="C" then
    gsobj.helpctrl:Display(a)
  end
end

function SendInfoEvent()
  local info,infodict="","<<"
  infodict=infodict.."/ProgramName (" .. PS_VIEW_NAME ..") "
    info=info.. _T("This is ") .. PS_VIEW_NAME ..", "
  infodict=infodict.."/ProgramVersion " .. PS_VIEW_VERSION .." "
    info=info.. _T("version ") .. PS_VIEW_VERSION .."\n"
  infodict=infodict.."/wxLuaName (" .. wxlua.wxLUA_VERSION_STRING ..") "
    info=info.. _T("built with ") .. wxlua.wxLUA_VERSION_STRING .." "
  infodict=infodict.."/LuaName (" .. _VERSION ..") "
    info=info.."(" .. _VERSION ..") "
  infodict=infodict.."/wxWidgetsName (" .. wx.wxVERSION_STRING ..") "
    info=info.. _T("and ") .. wx.wxVERSION_STRING .."\n"
  if gsobj.gsdll then
  infodict=infodict.."/GhostscriptVersion " .. gsobj.gsdll:GetVersion() .." "
    info=info.. _T("linked with Ghostscript ") .. gsobj.gsdll:GetVersion() .."\n" end
  infodict=infodict.."/OSDescription (" .. wx.wxGetOsDescription() ..") "
    info=info.. _T("running under ") .. wx.wxGetOsDescription() .."\n"
--
  if gsargs.psf_name~="" then
  infodict=infodict.."/OpenedFile (" .. gsargs.psf_name ..") "
    info=info.. _T("started on ") .. gsargs.psf_name .." "
  infodict=infodict.."/OpenedDir (" .. gsargs.psf_dir ..") "
    info=info.. _T("in ") .. gsargs.psf_dir .."\n"
  end
  infodict=infodict.."/GSDLL (" .. gsargs.dllloc ..") "
  infodict=infodict.."/GSLIB (" .. gsargs.libloc ..") "
  infodict=infodict.."/GSFONT (" .. gsargs.fontloc ..") "
  infodict=infodict.."/XGSLIB (" .. gsargs.gslib ..") "
  infodict=infodict.."/PSVLIB (" .. gsargs.psvlib ..") "
  infodict=infodict..">>"
  SendEventCommand ("INFO","(%s) %s 0",info,infodict)
end

function SendLocaleEvent(f,a)
  if f=="T" then
    local l=wx.wxGetTranslation(a)
    if l~=a then
      SendEventCommand ("LOCALE","(%s) (%s) 1",a,l)
    else
      SendEventCommand ("LOCALE","(%s) (%s) -1",a,a)
    end
  elseif f=="I" then
    SendEventCommand ("LOCALE","(%s) (%s) 0", gsobj.locale:GetLocale(),
      string.sub(gsobj.locale:GetName(),1,2))
  elseif f=="S" then
    local lang=gsobj.locale.FindLanguageInfo(a)
    SetLocale(lang.Language)
  end
end

function RunLuaCode(f,a)
  if f=="R" then
    local torun=loadstring(a)
    if torun then torun() end
  end
end

function StartDSCthread(fname)
  if gsobj.dscthread then return  end
  gsobj.dscthread=coroutine.wrap(ReadDSCcomments)
  local res=gsobj.dscthread(fname)
  if res==1 then     -- thread created succesfuly
  elseif res==0 then --        --''--             and finished
    gsobj.dscthread=function() return 0 end
  else
    error(_T("Unexpected error during creating DSC thread."))
  end
end

function ReadDSCcomments(fname)
  local psf_dir, psf_name = PSFName(fname)
  local ffname = psf_dir..psf_name
  local psfile,err=io.open(ffname,"rb")
  if not psfile then
    SendDSCEventCommand ("ENDDSC","(%s) %d %d",err,0,1)
    SetPSFile("","")
    return 0
  end
  SetPSFile(psf_dir, psf_name)
  local pstr=psfile:read(4)
  local pslen=psfile:seek("end")
  local psbeg,psend=0,pslen
  if pstr=="%PDF" then
    SendDSCEventCommand ("PDFFOUND","(%s) %d %d",ffname,0,pslen)
  else
    coroutine.yield(1)
    if pstr==string.char(0xC5,0xD0,0xD3,0xC6) then
      psfile:seek("set",4) pstr=psfile:read(8)
      local b={pstr:byte(1,4)} psbeg=b[1]+(b[2]+(b[3]+b[4]*256)*256)*256
      b={pstr:byte(5,8)} psend=psbeg+b[1]+(b[2]+(b[3]+b[4]*256)*256)*256
      if psend>pslen then
        print_message(_T("Improper preview information -- ignoring\n"))
        psbeg=0 psend=pslen
      end
    end
    SendDSCEventCommand ("FILEFOUND","(%s) %d %d",ffname,psbeg,psend)
    local pp=psfile:seek("set",psbeg)
    pstr=psfile:read("*l")
    local pn=psfile:seek()
    if pstr:match("^%%!PS") then
      SendDSCComment(pstr,pp,pn) -- %!PS Adobe
      coroutine.yield(1)
      local pstrec="\n"
      local psb,pse,pseb,psee,comm
      while pn<psend do
	if pstrec=="" and pstr:sub(-1):match("[\n\r%%]") then
	  pstrec=pstr:sub(-3) end
        pstr=psfile:read(60000)-- -/+ 2^16
        pp,pn=pn,psfile:seek()
        if pstrec~="" then
	  pstr=pstrec..pstr  pp=pp-pstrec:len()  pstrec="" end	
	pse=1
        while true do
          psb,pse = pstr:find("%%",pse,true)
          if psb then
            if pstr:sub(psb-1,pse):match("[\n\r]%%[%%D!]") then
              pseb,psee = pstr:find("[\n\r]+",pse)
   	      if pseb then
	        pse=psee
                SendDSCComment(pstr:sub(psb,pseb-1),pp+psb,pp+pse)
	      elseif pn==psend then
                pse=pstr:len()
                SendDSCComment(pstr:sub(psb,pse),pp+psb,pp+pse)
              elseif psb+1024<pstr:len() then
                pse=psb+255
                SendDSCComment(pstr:sub(psb,pse),pp+psb,pp+pse)
	      else	
 	        pse=pstr:len() pstrec=pstr:sub(psb-1)
	      end
	    end
          else break end
        end
        coroutine.yield(pn)
      end
--[[
--      for pstr in psfile:lines() do
--        if pstr:match("^%%[%%!D]") then
--          SendDSCEventCommand ("DSCCOMMENT","(%s) %d %d",pstr,pp,pn)
--          coroutine.yield(pp)
--        end
--      end
--]]
    end
  end
  SendDSCEventCommand ("ENDDSC","(%s) %d %d",ffname,0,0)
  psfile:close()
  return 0
end

function MakeStatusLine(l,m,a,b)
  if not gswin.statusBar then
    if l=="C" then gswin.statusBar=frame:CreateStatusBar() end
  elseif l=="D" then
    gswin.statusBar:Show(m~="F")
  elseif l=="P" then
    gsobj.SBsty,gsobj.SBall={},{}  local wid={}
    for wi,al,ap in a:gmatch("([0-9]+)([lcr]?)([tbn]?)") do
      wi=tonumber(wi) if wi==0 then wi=-1 end  table.insert(wid,wi)
      if al=="l" then al=2 elseif al=="r" then al=1 else al=3 end
      table.insert(gsobj.SBall,al)
      if ap=="t" then ap=wx.wxSB_RAISED elseif ap=="b" then ap=wx.wxSB_NORMAL
      else ap=wx.wxSB_FLAT end  table.insert(gsobj.SBsty,ap)
    end
    gswin.statusBar:SetFieldsCount(#wid)
    gswin.statusBar:SetStatusWidths(wid)
    gswin.statusBar:SetStatusStyles(gsobj.SBsty)
  elseif l=="T" then
    local i,al,ap=a:match("([0-9]+)([lcr]?)([tbn]?)")
    i=tonumber(i)
    if al=="l" then al=2 elseif al=="r" then al=1 elseif al=="c" then al=3 end
    if ap=="t" then ap=wx.wxSB_RAISED elseif ap=="n" then ap=wx.wxSB_FLAT
    elseif ap=="b" then ap=wx.wxSB_NORMAL end
    if not b then b="" end
    gswin.statusBar:SetStatusText(_T(b),i-1)
    if ap~="" then gsobj.SBsty[i]=ap end
    gswin.statusBar:SetStatusStyles(gsobj.SBsty)
  elseif l=="M" then
    local i=0	
    for t in a:gmatch("([^|]+)|") do
      if t~="" then gswin.statusBar:SetStatusText(_T(t),i) end i=i+1
    end
  end
end

function MakeMessageBox(kind, text)
   local style=wx.wxOK+wx.wxICON_INFORMATION
   if kind=="2" then style=style+wx.wxCANCEL end
   if kind=="3" then style=wx.wxYES_NO+wx.wxCANCEL+wx.wxICON_QUESTION end
   if kind=="4" then style=wx.wxYES_NO+wx.wxICON_QUESTION end
   -- local dialog=wx.wxMessageDialog(frame, title, PS_VIEW_NAME, style)
   -- local res=dialog:ShowModal()
   local res=wx.wxMessageBox(_T(text), PS_VIEW_NAME, style, frame)
   local restr="() 0 /UNKNOWN"
   if res==wx.wxOK then restr="() 1 /OK" end
   if res==wx.wxYES then restr="() 1 /YES" end
   if res==wx.wxNO then restr="() 2 /NO" end
   if res==wx.wxCANCEL then restr="() 3 /CANCEL" end
   SendEventCommand("MESSAGEBOX",restr)
end

function MakeFileDialogBox(kind, filter,file,ext,title)
  filter:gsub("||$","",1)
  local dialog
  if kind=="D" then
    local dir,title=filter,file
    if dir=="|" then dir=gsargs.psf_dir
    elseif dir=="|P" then dir=gsargs.psvlib
    elseif dir=="|G" then dir=gsargs.gslib end
    dialog=wx.wxDirDialog(frame, _T(title), dir)
  else
    local dir,style=gsargs.psf_dir,wx.wxFD_OPEN+wx.wxFD_FILE_MUST_EXIST
    if kind=="O" then
      if file=="|" then file=gsargs.psf_name end
    elseif kind=="S" then
      style=wx.wxFD_SAVE+wx.wxFD_OVERWRITE_PROMPT
    elseif kind=="L" then
      if file=="|" then file=gsargs.dllloc end
      local fname=wx.wxFileName(file)
      dir=fname:GetPath(wx.wxPATH_GET_VOLUME)
      file=fname:GetFullName()
    end
    dialog=wx.wxFileDialog(frame, _T(title), dir, file, _T(filter), style)
  end
--
  local res=dialog:ShowModal()
  if res==wx.wxID_OK then
    local resfull=dialog:GetPath()
    local resdir, resfn, fnoff = PSFName(resfull)
    resfull:gsub("\\","\\\\") resfull:gsub("%(","\\(") resfull:gsub("%)","\\)")
    if kind=="L" then
      SendEventCommand("LIBDIALOG", "(%s) (%s) 0", resdir..resfn, resfull)
    elseif kind=="D" then
      SendEventCommand("DIRDIALOG", "(%s) (%s) 0", resdir, resfull)
    elseif kind=="O" then
      local wild=dialog:GetFilterIndex()
      SendEventCommand("OPENDIALOG", "(%s) %d %d", resdir..resfn, fnoff, wild)
    elseif kind=="S" then
      SendEventCommand("SAVEDIALOG", "(%s) %d 0", resdir..resfn, fnoff)
    end
  end
  dialog:Destroy()
end

function MakeDialogBox(l, a,b,c,d)
  local function topixels(v) return math.ceil(2.5*tonumber(v)) end
  local dialog, objlst = gswin.dialog, gsobj.dialog
  local pos=wx.wxDefaultPosition
  local size=wx.wxDefaultSize
  local id,title="","Untitled"
  local type,state=a:sub(1,1),a:sub(2)
  if c then
    local x,y,w,h=c:match("([0-9]+),([0-9]+),([0-9]+),([0-9]+)")
    if x then
      pos=wx.wxPoint(topixels(x),topixels(y))
      size=wx.wxSize(topixels(w),topixels(h))
    end
    if b then id=b end
    if d then title=d end
  else
    local w,h=a:match("([0-9]+),([0-9]+)")
    if w then
      if wx.__WXMSW__ then h=h+10 end -- titlebar correction
      size=wx.wxSize(topixels(w),topixels(h))
    end
    if b then title=b end
  end
--
  if l=="I" then -- dialog box init
    gswin.dialog=wx.wxDialog(frame,wx.wxID_ANY,_T(title),pos,size)
    gsobj.dialog=MakeIdList()
    return
  else
    if dialog==nil then error("Operation on uninitialized DLGBOX.") end
  end
  if l=="B" then -- add push button
    if type=="O" then
      objlst:newObj(id,wx.wxButton(dialog,wx.wxID_OK,_T(title),pos,size))
    elseif type=="C" then
      objlst:newObj(id,wx.wxButton(dialog,wx.wxID_CANCEL,_T(title),pos,size))
    elseif type=="P" then
      local obj=objlst:newObj(id,wx.wxButton(dialog,wx.wxID_ANY,_T(title),pos,size))
      obj:Connect(wx.wxEVT_COMMAND_BUTTON_CLICKED, function (event)
        SendEventCommand("DIALOG", "() /%s /CLICKED",id) end )
    elseif type=="G" then
      objlst:newObj(id,wx.wxStaticBox(dialog,wx.wxID_ANY,_T(title),pos,size))
    end
  elseif l=="K" then -- add check button
    local obj
    if type=="K" then
      obj=objlst:newObj(id,wx.wxCheckBox(dialog,wx.wxID_ANY,_T(title),pos,size,wx.wxCHK_2STATE))
    elseif type=="3" then
      obj=objlst:newObj(id,wx.wxCheckBox(dialog,wx.wxID_ANY,_T(title),pos,size,wx.wxCHK_3STATE))
    elseif type=="S" then
      obj=objlst:newObj(id,wx.wxRadioButton(dialog,wx.wxID_ANY,_T(title),pos,size,wx.wxRB_GROUP))
    elseif type=="R" then
      obj=objlst:newObj(id,wx.wxRadioButton(dialog,wx.wxID_ANY,_T(title),pos,size,0))
    end
    if type=="3" then objlst:newCtrl(id,"CHECK3") else objlst:newCtrl(id,"CHECK") end
    if state=="C" or state=="+" then obj:SetValue(true)
    elseif state=="U" or state=="-" then obj:SetValue(false)
    elseif state=="N" or state=="0" then
      obj:Set3StateValue(wx.wxCHK_UNDETERMINED)
    end
  elseif l=="E" then -- add edit box
    local style,valid=wx.wxTE_LEFT,wx.wxDefaultValidator
    if type=="N" then
    elseif type=="P" then style=style+wx.wxTE_PASSWORD
    elseif type=="M" then style=style+wx.wxTE_MULTILINE
    elseif type=="D" then valid=wx.wxTextValidator(wx.wxFILTER_NUMERIC)
    end
    objlst:newObj(id,wx.wxTextCtrl(dialog,wx.wxID_ANY,_T(state),pos,size,style,valid))
    objlst:newCtrl(id,"EDIT")
  elseif l=="T" then -- add static (text)
    local style,text,border=wx.wxALIGN_CENTER,true,false
    if type=="C" then
    elseif type=="L" then style=wx.wxALIGN_LEFT
    elseif type=="R" then style=wx.wxALIGN_RIGHT
    elseif type=="D" then border=true
    elseif type=="U" then border=true
    elseif type=="W" then border=true text=false
    elseif type=="B" then border=true text=false
    end
    if border then
      objlst:newObj(id.."F",wx.wxStaticBox(dialog,wx.wxID_ANY,"",pos,size))
    end
    if text then
      local obj = objlst:newObj(id,
        wx.wxStaticText(dialog,wx.wxID_ANY,_T(title),pos,wx.wxDefaultSize,style))
      local nsize=obj:GetSize()
      pos=wx.wxPoint(pos.x+2,pos.y+(size:GetHeight()-nsize:GetHeight())/2+4)
      size:DecBy(4,4) obj:Move(pos) obj:SetSize(size)
    end
  elseif l=="L" then -- add list box
    local style,list,ini=wx.wxLB_SINGLE,{},nil
    if type=="M" then style=wx.wxLB_MULTIPLE end
    for v in state:gmatch("([^|]*)|") do if ini then table.insert(list,_T(v)) else ini=v end end
    local obj=objlst:newObj(id,wx.wxListBox(dialog,wx.wxID_ANY,pos,size,list,style))
    objlst:newCtrl(id,"LIST")
    if ini~="" then obj:SetSelection(tonumber(ini)) end
  elseif l=="C" then -- add combo (edit+list) box
    local style,list,ini=wx.wxCB_DROPDOWN,{},nil
    if type=="L" then style=wx.wxCB_SIMPLE end
    for v in state:gmatch("([^|]*)|") do if ini then table.insert(list,_T(v)) else ini=v end end
    local obj=objlst:newObj(id,wx.wxComboBox(dialog,wx.wxID_ANY,_T(title),pos,size,list,style))
    objlst:newCtrl(id,"COMBO")
    if ini~="" then obj:SetSelection(tonumber(ini)) end
  elseif l=="S" then -- dialog box start (show and process)
    ShowDialogBox()
    gswin.dialog:Destroy()
    gswin.dialog=nil gsobj.dialog=nil
  end
end

function ShowDialogBox()
  local result=gswin.dialog:ShowModal()
  if result==wx.wxID_OK then result="OK"
    for i,v in ipairs(gsobj.dialog) do
      local type, obj, res = v.type, gsobj.dialog:getObj(v.id), ""
      if type=="CHECK" then
        type="UNCHECKED"
        if obj:GetValue() then type="CHECKED" end
      elseif type=="CHECK3" then
        type="UNCHECKED"
        if obj:Get3StateValue()==wx.wxCHK_UNDETERMINED then type="INDETERMINATE"
        elseif obj:Get3StateValue()==wx.wxCHK_CHECKED then type="CHECKED" end
      elseif type=="EDIT" then
        res=obj:GetValue()
      elseif type=="LIST" then
        for i=0,obj:GetCount()-1 do
          if obj:IsSelected(i) then res=res.."1" else res=res.."0" end
        end
      elseif type=="COMBO" then
        res=obj:GetValue()
      else
        error(_T("Unknown type of control in ShowDialog -- can't happen."))
      end
      SendEventCommand("DIALOG", "(%s) /%s /%s", res, v.id, type)
    end
  elseif result==wx.wxID_CANCEL then result="CANCEL"
  else result="UNDEFINED" end
  SendEventCommand("DIALOG", "() /%s /ENDDIALOG", result)
end

function MakeMenu(l,m,a,b,c)
  local objlst=gsobj.menu
  if not gswin.menuBar then
    gswin.menuBar=wx.wxMenuBar()
    objlst:newObj("MAIN",gswin.menuBar)
    frame:SetMenuBar(gswin.menuBar)
  end
  if l=="I" then
    local pare=objlst:getObj(a)
    if not pare then return false end
    if m=="C" then -- extra option required by wxWidgets
      pare:AppendCheckItem(objlst:newId(b),_T(c))
    else
      pare:Append(objlst:newId(b),_T(c))
    end
  elseif l=="S" then
    local pare=objlst:getObj(a)
    local menu=objlst:newObj(b,wx.wxMenu())	
    if not pare or not menu then return false end
    if a=="MAIN" then
      pare:Append(menu,_T(c))
    else
      pare:Append(objlst:newId(b),_T(c),menu)
    end
  elseif l=="H" then
    local pare=objlst:getObj(a)
    if pare then pare:AppendSeparator() else return false end
  elseif l=="C" then
    local item=gswin.menuBar:FindItem(objlst:getId(a))
    if item then item:SetText(_T(b)) else return false end
  elseif l=="U" then
    local item=gswin.menuBar:FindItem(objlst:getId(a))
    if not item then return false end
    item:Enable(m=="N" or m=="C")
    item:Check(m=="C" or m=="B")
  elseif l=="D" then
    gswin.menuBar:Show(m~="F")
    if m=="R" then gswin.menuBar:Refresh() end
  end
end

function DrawObjectEvent(f,s,id,dim,pen)
  if f=="O" then
    if s=="C" then CreateOverlay()
    elseif s=="D" then DestroyOverlay()
    elseif s=="T" then ToggleOverlay() end
  elseif f=="D" then
    if s=="A" then AddDrawObject(id,dim,pen)
    elseif s=="M" then MoveDrawObject(id,dim,pen)
    elseif s=="D" then DeleteDrawObject(id)
    elseif s=="M" then ClearDrawObjects() end
  end 	
end

function CreateOverlay()
  local w, h = gsobj.image.w, gsobj.image.h
  if not gsobj.bbmp then gsobj.bbmp=wx.wxBitmap(w,h) end
  if not gsobj.obmp then gsobj.obmp=wx.wxBitmap(w,h) end
  local bdc=wx.wxMemoryDC()
  bdc:SelectObject(gsobj.bbmp)
  gsobj.image:CopyOnto(bdc,0,0,w,h,0,0)
  bdc:delete()
  if Dobject.n==0 then
    gswin.gswindow:Connect(wx.wxEVT_PAINT, OnPaintExtra)
  end
  gsstat.inoverlay=true	
  gsstat.drawoverlay=true	
end

function ToggleOverlay()
  gsstat.drawoverlay = not gsstat.drawoverlay
end

function DestroyOverlay()
  if gsstat.inoverlay then
    gsstat.inoverlay=false
    if gsstat.drawoverlay then
      gsobj.image=gsobj.overlay
      gswin.gswindow:SetGsImage(gsobj.image)
      gsstat.drawoverlay=false
    end
    gsobj.overlay=nil
    if gsobj.bbmp then gsobj.obmp:delete() gsobj.obmp=nil end
    if gsobj.obmp then gsobj.bbmp:delete() gsobj.bbmp=nil end
  end
  if Dobject.n==0 then
    gswin.gswindow:Disconnect(wx.wxEVT_PAINT)
  end
end

function OnPaintExtra(event)
  local dc,sdc
  local xd, yd, w, h, xs, ys = 0, 0, gsobj.image.w, gsobj.image.h, 0, 0
  dc=wx.wxPaintDC(gswin.gswindow)
  if gsstat.inoverlay then
    if gsstat.drawoverlay then
      dc:DrawBitmap(gsobj.bbmp,0,0,false)
    else
      -- if gsobj.image.r then
      sdc=wx.wxMemoryDC() sdc:SelectObject(gsobj.bbmp)
      gsobj.image:CopyOnto(sdc,xd,yd,w,h,xs,ys)
      sdc:delete()
      gsobj.image:CopyOnto(dc,xd,yd,w,h,xs,ys)
    end
    if gsobj.overlay then
      sdc=wx.wxMemoryDC() sdc:SelectObject(gsobj.obmp)
      if gsstat.drawoverlay and gsobj.overlay.r then
         gsobj.overlay.r=false
         gsobj.overlay:CopyOnto(sdc,xd,yd,w,h,xs,ys)
         sdc:delete()
         local omask=wx.wxMask(gsobj.obmp,wx.wxWHITE)
         gsobj.obmp:SetMask(omask)
         sdc=wx.wxMemoryDC() sdc:SelectObject(gsobj.obmp)
      end
      -- dc:Blit(xd,yd,w,h,sdc,xs,ys,wx.wxEQUIV) --EQUIV
      dc:Blit(xd,yd,w,h,sdc,xs,ys,wx.wxCOPY,true)
      sdc:delete()
    end
  else
    gsobj.image:CopyOnto(dc,xd,yd,w,h,xs,ys)
  end
  if Dobject.n>0 then
    -- draw objects
  end
  dc:delete()
end

function AddDrawObject(id,dim,pen)
  if Dobject.n==0 then CreateDrawObjects() end
  if not Dobject.id[id] then
    Dobject.n=Dobject.n+1  Dobject.id[id]=Dobject.n
    Dobject[Dobject.n]={id = id, xb = xb, yb = yb, xe = xe, ye = ye,
      pe = pe, br = br}
  else
    MoveDrawObject(id,dim,pen)
  end
end

function MoveDrawObject(id,dim,pen)
  if Dobject.id[id] then
    Dobject[Dobject.id[id]]={id = id, xb = xb, yb = yb, xe = xe, ye = ye,
      pe = pe, br = br}
  end
end

function DeleteDrawObject(id)
  if Dobject.id[id] then
    local k=Dobject.id[id]
    Dobject.id[id]=nil
    Dobject.n=Dobject.n-1
    for i=k,Dobject.n do
      Dobject[i]=Dobject[i+1]
      Dobject.id[Dobject[i].id]=i
    end
    Dobject[Dobject.n+1]=nil
  end
  if Dobject.n==0 then ClearDrawObjects() end
end

function CreateDrawObjects()
  if not gsstat.inoverlay then
    gswin.gswindow:Connect(wx.wxEVT_PAINT, OnPaintExtra)
  end
end

function ClearDrawObjects()
  if Dobject.n>0 then
    for i=1,Dobject.n do Dobject[i]=nil end
    Dobject.n=0  Dobject.id={}
    if not gsstat.inoverlay then
      gswin.gswindow:Disconnect(wx.wxEVT_PAINT)
    end
    -- gswin.gswindow:Refresh()
  end
end

function MakeResizeEvent(f,s,x,y)
  if f=="F" then
    if s=="T" then frame:ShowFullScreen(true)
    elseif s=="F" then frame:ShowFullScreen(false) end
  elseif f=="S" then
  end 	
end

function MouseButtonEvent(event)
  local mod=wx.wxMOD_NONE
  if event:AltDown() then mod=mod+wx.wxMOD_ALT end
  if event:ControlDown() then mod=mod+wx.wxMOD_CONTROL end
  if event:ShiftDown() then mod=mod+wx.wxMOD_SHIFT end
  Mouse.mod=mod
  if event:ButtonDown() then
    Mouse.bx,Mouse.by=event:GetPositionXY()	
    Mouse.ex,Mouse.ey=Mouse.bx,Mouse.by
    if Mouse.CMD==Mouse.Cnone and event:LeftDown() then
      if wx.wxGetKeyState(32) then
	Mouse.CMD=Mouse.Cpane
      else
        Mouse.CMD=Mouse.Czoom
      end
    elseif Mouse.CMD==Mouse.Cnone and event:RightDown() then
      if not event:ControlDown() then
        Mouse.CMD=Mouse.Cmeasure
      else
        -- Mouse.CMD=Mouse.Cendmeas
        SendMouseCommandWithStatus(Mouse,"MEAS")
      end
    end
    if Mouse.CMD~=Mouse.Cnone then
      local cursor=wx.wxNullCursor
      if Mouse.CMD==Mouse.Cpane then cursor=Mouse.cursorHand end
      if Mouse.CMD==Mouse.Czoom then cursor=Mouse.cursorMag end
      if Mouse.CMD==Mouse.Cmeasure then cursor=Mouse.cursorCross end
      gswin.gswindow:SetCursor(cursor)
      gswin.gswindow:CaptureMouse()
      DrawMouseRules()
    end
  elseif event:ButtonDClick() then
    Mouse.bx,Mouse.by=event:GetPositionXY()	
    Mouse.ex,Mouse.ey=Mouse.bx,Mouse.by
    if event:LeftDClick() then
      -- Mouse.CMD=Mouse.Cdblclick
      SendMouseCommandWithStatus(Mouse,"LDBLCLICK")
    end
  elseif event:ButtonUp() then
    if Mouse.CMD~=Mouse.Cnone then
      DrawMouseRules()
      Mouse.ex,Mouse.ey=event:GetPositionXY()	
      gswin.gswindow:ReleaseMouse()
      gswin.gswindow:SetCursor(wx.wxNullCursor)
      if Mouse.CMD==Mouse.Czoom then
        if math.abs(Mouse.ex-Mouse.bx)>1 or math.abs(Mouse.ey-Mouse.by)>1 then
          SendMouseCommandWithStatus(Mouse,"ZOOM") end
      elseif Mouse.CMD==Mouse.Cpane then
        if math.abs(Mouse.ex-Mouse.bx)>1 or math.abs(Mouse.ey-Mouse.by)>1 then
          SendMouseCommandWithStatus(Mouse,"MOVE") end
      elseif Mouse.CMD==Mouse.Cmeasure then
        SendMouseCommandWithStatus(Mouse,"MEAS")
      end
      Mouse.CMD=Mouse.Cnone
    end
  end
  event:Skip()
end

function SendWheelEvent()
 SendMouseCommand (Mouse.scroln,0,0,0,"SCROLL",mod_text[Mouse.mod])
 Mouse.CMD=Mouse.Cnone Mouse.scroln=0
end

function MouseWheelEvent(event)
  if Mouse.timer~=0 then ResetDelayedDo(Mouse.timer) Mouse.timer=0 end
  Mouse.CMD=Mouse.Cscroll Mouse.scroln=Mouse.scroln+event:GetWheelRotation()
  Mouse.bx,Mouse.by=0,0
  if event:ControlDown() or wx.wxGetKeyState(32) then
    Mouse.ex,Mouse.ey,Mouse.mod=Mouse.scroln/1200*gsobj.image.w,0,wx.wxMOD_CONTROL
  else
    Mouse.ex,Mouse.ey,Mouse.mod=0,Mouse.scroln/1200*gsobj.image.h,wx.wxMOD_NONE
  end
  DrawMouseRules()
  if Mouse.scroln~=0 then
    Mouse.timer=SetDelayedDo(200,function() SendWheelEvent() Mouse.timer=0 end)
  end
  event:Skip()
end

function MouseMotionEvent(event)
  if Mouse.CMD~=Mouse.Cnone and Mouse.CMD~=Mouse.Cscroll then
    DrawMouseRules()
    Mouse.ex,Mouse.ey=event:GetPositionXY()	
    DrawMouseRules()
  end
  event:Skip()	
end

function DrawMouseRules()
  local dc=wx.wxClientDC(gswin.gswindow)
  if Mouse.CMD==Mouse.Czoom then
    dc:SetLogicalFunction(wx.wxEQUIV)
    dc:SetBrush(wx.wxTRANSPARENT_BRUSH)
    dc:SetPen(Mouse.penRed)
    dc:DrawRectangle(Mouse.bx,Mouse.by,Mouse.ex-Mouse.bx,Mouse.ey-Mouse.by)
  elseif Mouse.CMD==Mouse.Cmeasure then
    dc:SetLogicalFunction(wx.wxEQUIV)
    dc:SetPen(Mouse.penBlue)
    dc:CrossHair(Mouse.ex,Mouse.ey)
  elseif Mouse.CMD==Mouse.Cpane or Mouse.CMD==Mouse.Cscroll then
    dc:SetLogicalFunction(wx.wxCOPY)
    dc:SetBrush(wx.wxLIGHT_GREY_BRUSH)
    dc:SetPen(wx.wxTRANSPARENT_PEN)
    local xs, ys, w, h = 0, 0, gsobj.image.w, gsobj.image.h
    local xd, yd = Mouse.ex-Mouse.bx , Mouse.ey-Mouse.by
    if xd<0 then
      xs,xd=-xd,0  dc:DrawRectangle(w-xs,0,xs,h)
    else
      w=w-xd       dc:DrawRectangle(0,0,xd,h)
    end
    if yd<0 then
      ys,yd=-yd,0  dc:DrawRectangle(0,h-ys,w+xd,ys)
    else
      h=h-yd       dc:DrawRectangle(0,0,w+xd,yd)
    end
    gsobj.image:CopyOnto(dc,xd,yd,w,h,xs,ys)
  end
  dc:delete()
end

do local resize = { timer=0, pw=0, ph = 0}

function SendResizeEvent(w,h)
  if w~=resize.pw or h~=resize.ph then
    if w*h>resize.pw*resize.ph*2 or w*h*2<resize.pw*resize.ph then
      gsstat.refr_int=0 -- update refresh timer to new image size
      gsstat.refresh=0
    end
    SendEventCommand ("RESIZE","() %d %d",w,h)
    resize.pw=w resize.ph=h
  end
end

function ProcessResizeEvent(w,h)
  if resize.timer~=0 then ResetDelayedDo(resize.timer) resize.timer=0 end
  if h~=0 and w~=0 then
    resize.timer=SetDelayedDo(140,function() SendResizeEvent(w,h) resize.timer=0 end)
  end
end

end -- resize

function SendKeyEvent(code,modif,down)
  if not down then return false end
  print_debug("Key pressed: ", code, modif, "\n")
  if key_text[code] then
    SendKeyCommand (key_text[code],mod_text[modif])
  elseif char_text[code] and bit.band(modif,wx.wxMOD_MORE_THAN_SHIFT)>0 then
    SendKeyCommand (char_text[code],mod_text[modif])
  else
    return false
  end
  return true
end

do local inputstr = ""

function SendCharEvent(event)
  local code=event:GetKeyCode()
  if char_shift_text[code] then
    SendKeyCommand (char_shift_text[code],"SHIFT")
    return false
  else
    return EditInputLine(code)
  end
end

function EditInputLine(code)
  if console then inputstr=gswin.editwindow:GetValue()end
  if code==wx.WXK_RETURN then
    if inputstr=="" then RunPScode:add("/RETURN /NORM KEYCOMMAND") end
    RunInputString()
  elseif code==wx.WXK_BACK then
    inputstr=inputstr:sub(1,-2)
    if console then
      local pos=gswin.editwindow:GetInsertionPoint()
      gswin.editwindow:Remove(pos-1, pos)
    end
  elseif code > 31 and code < 127 then
    local char=string.char(code)
    inputstr=inputstr .. char
    if console then gswin.editwindow:WriteText(char) end
  else
    return false
  end
  return true
end

function RunInputString()
  if console then inputstr=gswin.editwindow:GetValue()end
  if inputstr~="" then
    RunPScode:add("{" .. inputstr .. "} stopped {handleerror} if")
  end
  inputstr="" if console then gswin.editwindow:Clear() end
end

end -- inputstr

function StartCheckUpdate ()
  if gsstat.update~=0 then return end
  gsstat.update=SetDelayedDo(300,CheckUpdate)
end
function StopCheckUpdate ()
  if gsstat.update~=0 then ResetDelayedDo(gsstat.update) gsstat.update=0 end
end
function CheckUpdate ()
  gsstat.update=0
  if gsstat.working then return end
  if gsobj.instancechecker:IsLockUpdated() then
    SendEventCommand ("REFRESH","(%s) 1 /THISFILE",gsargs.psf_dir..gsargs.psf_name)
  else
    StartCheckUpdate ()
  end
end

function InitializeGS ()

  gsobj.gsdll = wxghost.wxGsDll(gsargs.dllloc, gsargs.libloc, gsargs.fontloc)

  if (not gsobj.gsdll:isOK()) then
    ExitPSV_init() error(_T("Failed to link to Ghostscript library"),1)
  end

  gsobj.ghostscript = wxghost.wxLuaGhostscript()

  gswin.gswindow = wxghost.wxGsWindowX(frame,wx.wxID_ANY)

  local stdoutstr = ""
  gsobj.ghostscript.OnStdout = function(self, GsOut)
    stdoutstr=stdoutstr..GsOut
    local line,rest=stdoutstr:match("^(.*\n)([^\n]*)$")
    if line then
      stdoutstr=rest
      local _m,_p = line:match("^(!PSV_)(.*)$")
      if _m then
        CallPSVhook(_p)
      else
        print_message(line)
      end
    end
    if gsstat.ready and wxapp:Pending() then
      gsobj.ghostscript:Suspend()
    end
  end

  gsobj.ghostscript.OnStderr = function(self, GsOut)
    print(GsOut)
    if gsstat.ready and wxapp:Pending() then
      gsobj.ghostscript:Suspend()
    end
  end

  gsobj.ghostscript.OnStdin = function(self)
    print_debug("!!!StdIn (PS_View?)\n")
    if gsstat.ready then
       gsobj.ghostscript:Suspend()
       if not StdInCode:isEmpty() then
         return StdInCode:get() .. "\n"
       else
         return "\n"
       end
    else
      return ""
    end
  end

  -- gsobj.ghostscript.OnPoll = function(self)
  --   print_debug("!!!Poll callback\n")
  --   return 0
  -- end

  gsobj.ghostscript.OnDisplayOpen = function(self, Image)
    print_debug("!Display_Open", Image, "\n")
    if gsstat.ready and wxapp:Pending() then
      gsobj.ghostscript:Suspend()
    end
    return 0
  end

  -- gsobj.ghostscript.OnDisplayPreSize = function(self, Image) return 0 end
  gsobj.ghostscript.OnDisplaySize = function(self, Image)
    print_debug("!Display_Size (image ready)", Image, "\n")
    if gsstat.drawoverlay then
      gsobj.overlay=Image
      gsobj.overlay.w=Image:GetWidth() gsobj.overlay.h=Image:GetHeight()
      gsobj.overlay.r=false
    else	
      gsobj.image=Image
      gsobj.image.w=Image:GetWidth() gsobj.image.h=Image:GetHeight()
      gswin.gswindow:SetGsImage(gsobj.image) gsobj.image.r=false
    end
    if gsstat.ready and wxapp:Pending() then
      gsobj.ghostscript:Suspend()
    end
    return 0
  end

  gsobj.ghostscript.OnDisplaySync = function(self, Image)
    print_debug("!Display_Sync", Image, "\n")
    if gsstat.drawoverlay and gsobj.overlay.r or gsobj.image.r then
      gswin.gswindow:Refresh()
    end
    if gsstat.drawoverlay then gsobj.overlay.r=true else gsobj.image.r=true end
    if gsstat.ready and wxapp:Pending() then
      gsobj.ghostscript:Suspend()
    end
    return 0
  end

  gsobj.ghostscript.OnDisplayPage = function(self, Image, copies, flush)
    print_debug("!!!Display_Page (PS_View?)\n")
    if gsstat.ready then
      gsobj.ghostscript:Suspend()
      gswin.gswindow:Refresh()
      gsstat.working=false
    end
    return 0
  end

  local rect,mul=nil,0
  -- OnDisplayUpdate is called on every graphic object (it is too frequent to update window)
  gsobj.ghostscript.OnDisplayUpdate = function(self, Image, Rect)
    if gsstat.ready then
      -- if rect then rect=rect:Union(Rect) else rect=wx.wxRect(Rect) end
      if gsstat.refresh==0 then
        gsstat.refresh=SetTimer(gsstat.refr_int)
      elseif CheckTimer(gsstat.refresh) then
        if gsstat.drawoverlay then gsobj.overlay.r=true else gsobj.image.r=true end
        gswin.gswindow:Refresh()
        -- gswin.gswindow:Refresh(false,rect)
        if gsstat.refr_int==0 then
          local sw=wx.wxStopWatch()
          -- gswin.gswindow:Refresh()
          gswin.gswindow:Update()
          gsstat.refr_int=5*sw:Time()
          print_debug(_T("Update Interval: ") .. gsstat.refr_int .. " ms\n")
        end
        gsstat.refresh=SetTimer(gsstat.refr_int)
      end
      if wxapp:Pending() then
        gsobj.ghostscript:Suspend()
      end
    end
    return 0
  end

  -- gsobj.ghostscript.OnDisplayPreClose = function(self, Image) return 0 end
  gsobj.ghostscript.OnDisplayClose = function(self, Image)
    print_debug("!Display_Close (image delete)", Image, "\n")
    -- close may be called more than one time, so delay window destroy
    return 0
  end

  return true
end

function StartGS ()

  gsobj.ghostscript:Create(gsobj.gsdll, gsargs.args, wxghost.wxGhostscript.colour) -- greyscale)

  local err=gsobj.ghostscript:GetExitCode()
  if err==wxghost.e_Info then return false end
  if err==wxghost.e_Quit then return false end
  if (gsobj.ghostscript:isReady()) then
    gsstat.ready=true
  else
    ExitPSV_init() error(_T("Failed to start Ghostscript"),1)
  end

  RunPScode:insert("start")

  return true
end

function PushRunGS ()
  local torun, isdsc = RunPScode, gsobj.dscthread
  if  isdsc then
    if not wx.wxIsBusy() then wx.wxBeginBusyCursor() end
    torun=RunDSCcode
    if gsobj.dscthread()==0 then
      if torun:isEmpty() then  gsobj.dscthread=nil
      else gsobj.dscthread=function() return 0 end end
    end
  end
  if gsstat.working then
    if gsobj.ghostscript:isSuspended() then
      gsobj.ghostscript:Resume()
      return true
    elseif gsobj.ghostscript:isReady() then
      if not isdsc then
        if gsstat.drawoverlay then gsobj.overlay.r=true else gsobj.image.r=true end
        gswin.gswindow:Refresh()
      end
      gsstat.working=false
    end
  end
  if not gsstat.working then
    if torun:isEmpty() then
      if isdsc then return true -- read more DSC
      else
        if wx.wxIsBusy() then wx.wxEndBusyCursor() end
        StartCheckUpdate()
        return false -- nothing to do
      end
    elseif gsobj.ghostscript:isReady() then
      if not wx.wxIsBusy() then wx.wxBeginBusyCursor() end
      StopCheckUpdate()
      gsstat.working=true gsstat.refresh=0
      local code=torun:getMax()
      print_debug(_T("RunPS>>") .. code .."\n")
      gsobj.ghostscript:RunString(code)
      return true
    end
  end
  return not IsGSerror()
end

function ClosePSV ()
--  print_debug(wxlua.GetGCUserdataInfo(true))
--  print_debug(wxlua.GetTrackedObjectInfo(true)) -- !!
  if gsstat.ready then
    if gsstat.update~=0 then ResetDelayedDo(gsstat.update) end
    gsobj.gstimer:Stop()
    gsstat.ready=false
    print_debug(_T("Close, quit\n"))
    gsobj.ghostscript:Terminate(wxghost.e_Quit)
  end
  if trans then trans:close() end -- for locale text extraction
  if wx.wxIsBusy() then wx.wxEndBusyCursor() end
  if gswin.gswindow then gswin.gswindow:Destroy() gswin.gswindow=nil end
  if gsobj.instancechecker then gsobj.instancechecker:Destroy(true) end
  -- ConfigSavePaths(gsargs)
  ConfigSaveFramePosition(frame, "MainWindow")
  if console then
    ConfigSaveFramePosition(console, "ConsoleWindow")
    console:Destroy()
    console=nil
  end
  gsobj.config:Flush()
  frame:Destroy()
end

function IsGSerror()
  if gsobj.ghostscript:isSuspended() or gsobj.ghostscript:isReady() then
    return false
  end
  ExitPSV(gsobj.ghostscript:GetExitCode())
  return true
end

function ExitPSV (err_code)
  if err_code==0 then frame:Close() return end
  if gsstat.ready then
    if gsstat.update~=0 then ResetDelayedDo(gsstat.update) end
    gsobj.gstimer:Stop()
    gsstat.ready=false
    gsobj.ghostscript:Terminate(err_code)
  end
  if wx.wxIsBusy() then wx.wxEndBusyCursor() end
  if gsobj.instancechecker then gsobj.instancechecker:Destroy(true) end
  if console then
    console:Show() frame:Hide()
    console:Connect(wx.wxEVT_CLOSE_WINDOW, function (event)
      console:Destroy() frame:Destroy() end)
  else
    frame:Destroy()
  end
end

function ExitPSV_init ()
  if gsstat.ready then
    gsstat.ready=false
    gsobj.ghostscript:Terminate(gsobj.ghostscript:GetExitCode())
  end
  if wx.wxIsBusy() then wx.wxEndBusyCursor() end
  if gsobj.instancechecker then gsobj.instancechecker:Destroy(true) end
  if console then wxapp:SetTopWindow(console) end
  if frame then frame:Destroy() end
end

do local time, todo = 0, {}

function TimerTick()
  time=time+1
  if todo[time] then
    todo[time]() todo[time]=nil
    wx.wxWakeUpIdle()
  end
end
function GetCurrTime() return time end
function SetTimer(delta) return time+math.ceil(delta/20) end
function CheckTimer(fin) return time>=fin end
function SetDelayedDo(delta,run)
  local fin=SetTimer(delta)
  while todo[fin] do fin=fin+1 end
  todo[fin]=run
  return fin
end
function ResetDelayedDo(fin) todo[fin]=nil end

end

function ConnectEvents ()

  gsobj.gstimer = wx.wxTimer(frame)
  frame:Connect(wx.wxEVT_TIMER, TimerTick)
  gsobj.gstimer:Start(20)

  local in_iddle = false
  frame:Connect(wx.wxEVT_IDLE, function (event)
    if in_iddle then return end in_iddle=true
    if PushRunGS() then event:RequestMore() end
    in_iddle=false end)
	
  frame:Connect(wx.wxEVT_CLOSE_WINDOW, function (event)
    ClosePSV() event:Skip() end)

  frame:Connect(wx.wxEVT_COMMAND_MENU_SELECTED, function (event)
    SendMenuCommand(gsobj.menu:getName(event:GetId()),"NORM")
  end )

  -- gswin.gswindow:Connect(wx.wxEVT_ERASE_BACKGROUND, function (event) end)
  gswin.gswindow:SetBackgroundStyle(wx.wxBG_STYLE_CUSTOM)

  gswin.gswindow:Connect(wx.wxEVT_SIZE, function (event)
    local size = event:GetSize()
    ProcessResizeEvent(size:GetWidth(),size:GetHeight())
    event:Skip()
  end )

  gswin.gswindow:Connect(wx.wxEVT_LEFT_DOWN, MouseButtonEvent)
  gswin.gswindow:Connect(wx.wxEVT_LEFT_UP, MouseButtonEvent)
  gswin.gswindow:Connect(wx.wxEVT_LEFT_DCLICK, MouseButtonEvent)
  gswin.gswindow:Connect(wx.wxEVT_RIGHT_DOWN, MouseButtonEvent)
  gswin.gswindow:Connect(wx.wxEVT_RIGHT_UP, MouseButtonEvent)
  gswin.gswindow:Connect(wx.wxEVT_RIGHT_DCLICK, MouseButtonEvent)
  gswin.gswindow:Connect(wx.wxEVT_MOUSEWHEEL, MouseWheelEvent)
  gswin.gswindow:Connect(wx.wxEVT_MOTION, MouseMotionEvent)


  PrepareKeyNames()

  gswin.gswindow:Connect(wx.wxEVT_KEY_DOWN, function (event)
    if not SendKeyEvent(event:GetKeyCode(),event:GetModifiers(),true) then event:Skip() end
  end )
  gswin.gswindow:Connect(wx.wxEVT_KEY_UP, function (event)
    if not SendKeyEvent(event:GetKeyCode(),event:GetModifiers(),false) then event:Skip() end
  end )
  gswin.gswindow:Connect(wx.wxEVT_CHAR, function (event)
    if not SendCharEvent(event) then event:Skip() end
  end )

end

function InitializeConsole()
  console=console:DynamicCast("wxFrame")
  -- assume that console frame has one child, and this is TextCtrl !
  gswin.logwindow = console:GetChildren():Item(0):GetData():DynamicCast("wxTextCtrl")
  gswin.editwindow = wx.wxTextCtrl(console, wx.wxID_ANY, "",
    wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxTE_PROCESS_ENTER)
  consolesizer=wx.wxBoxSizer(wx.wxVERTICAL)
  consolesizer:Add(gswin.logwindow,1,wx.wxEXPAND)
  consolesizer:AddSpacer(2)
  consolesizer:Add(gswin.editwindow,0,wx.wxEXPAND)
  console:SetSizerAndFit(consolesizer)
  gswin.editwindow:SetFocus()

  gswin.logwindow:Connect(wx.wxEVT_CHAR, function (event)
    if event:GetKeyCode()==wx.WXK_RETURN then RunInputString()
    else gswin.editwindow:EmulateKeyPress(event) end event:Skip()
  end )
  gswin.editwindow:Connect(wx.wxEVT_COMMAND_TEXT_ENTER, function (event)
    RunInputString()
  end )
end

function PSFName(name)
  if not name or name=="" then return "","",0 end
  local fname=wx.wxFileName(name)
  fname:Normalize()
  local resdir=fname:GetVolume() .. fname.GetVolumeSeparator() ..
       fname:GetPath(wx.wxPATH_GET_SEPARATOR,wx.wxPATH_UNIX)
  local resfn=fname:GetFullName(wx.wxPATH_UNIX)
  return resdir,resfn,#resdir
end

function SetPSFile(fdir,fname)
  if gsargs.psf_dir ~= fdir or gsargs.psf_name ~= fname then
    gsargs.psf_dir, gsargs.psf_name = fdir,fname
    SetPSTitle(fname)
    if gsobj.instancechecker then gsobj.instancechecker:Destroy(false) end
    gsobj.instancechecker = CreateInstanceChecker()
  end  
  gsobj.instancechecker:IsAnotherInstance()
end

function SetPSTitle(fname)
  local wtitle=PS_VIEW_NAME
  if fname~="" then wtitle=fname .. " -- " .. wtitle end
  frame:SetTitle(wtitle)
  if console then console:SetTitle(wtitle .. _T(" Console")) end
end

function PrintUsageInfo(appname,luaname)
  print(_T("This is ") .. PS_VIEW_VERSION_STRING .. _T(" working on wxLuaGhostscript;\n"))
  print(_T("built with ") .. wxlua.wxLUA_VERSION_STRING .. _T(" and ") .. wx.wxVERSION_STRING)
  if gsobj.gsdll then
    print(_T(";\nlinked with Ghostscript ") ..string.format("%g",gsobj.gsdll:GetVersion())) end
  print(_T(".\n\nUsage:  ") .. appname .. _T(" [-h|--help] [-c|--console] [-l|--lua] ")
    .. luaname .. _T(" [options] [-p|--ps] PS_View.ps [-- [more options]]\n"))
  print(_T("  -h, --help      help on command line arguments;\n"))
  print(_T("  -c, --console   show message console;\n"))
  print(_T("  -l, --lua       wxLua script to construct application;\n"))
  print(_T("  -p, --ps        PostScript program to run;\n"))
  print(_T("  -q, --quiet     turn off most of messages;\n"))
  print(_T("  -v, --verbose   turn on verbose/debug mode and console;\n"))
  print(_T("  -n, --new       open new window for document;\n"))
  print(_T("  -w, --watch     watch for document changes;\n"))
  print(_T("  -g, --gsdll     path to Ghostscript .dll/.so file;\n"))
  print(_T("  -i, --gslib     paths to Ghostscript init files;\n"))
  print(_T("  -s, --gsset     ghostscript parameter (-s equivalent);\n"))
  print(_T("  -d, --gsdef     ghostscript parameter (-d equivalent);\n"))
  print(_T("  --              all following argument will be directly passed to\n"))
  print(_T("                  Ghostscript before the PostScript (-p) program name;\n"))
  if console then console:Show() end
end

function GetParameter(argt,i,short,long)
  assert(argt[i],"Assertion falied -- parameter number out of range")
  local _m,_p = argt[i]:match("^(%-"..short..")(.*)$")
  if not _m then _m,_p = argt[i]:match("^(%-%-"..long..")(.*)$") end
  if not _m then return false end
  if _p=="" then return true
  else
    error(_T("Option: ") .. _m .. _T(" has a unexpected value: ") .. _p ..
          _T("\nUse -h or --help option for usage.\n"))
  end
end

function GetParameterValue(argt,i,short,long)
  assert(argt[i],"Assertion falied -- parameter number out of range")
  local _m,_p = argt[i]:match("^(%-"..short..")(.*)$")
  if not _m then _m,_p = argt[i]:match("^(%-%-"..long..")(.*)$") end
  if not _m then return false,0 end
  if _p=="" then
    local _n=argt[i+1]
    if _n and _n:sub(1,1)~="-" then return _n,1
    else
      error(_T("Option: ") .. _m .. _T(" must have a value.") ..
          _T("\nUse -h or --help option for usage.\n"))
    end
  else
    return _p,0
  end
end

function ParseCommandLine(argt)
  if argt then
    local function addgsarg(v) table.insert(gsargs.args, v) end
    -- arguments pushed into wxLua are
    --   [C++ app and it's args][lua prog at 0][args for lua start at 1]
    local n,to_gs,psf_name = 0,false,nil
    while argt[n-1] do n = n - 1 end

     -- n == exe program name
    local i,_v,_i=n+1
    repeat
      print_debug("args: ", i, argt[i], "\n")
      _v,_i=false,0
      -- 0 == this program name
      if i==0 then _v=true end
      if to_gs then
        _v=argt[i] addgsarg(_v)
      end
      if argt[i]=="--" then
        to_gs=true
        _v=true
        assert(i>0,"Assert failed -- parameter passing error")
      end
      if not _v then
        _v = GetParameter(argt,i,"h","help")
        if _v then
          PrintUsageInfo(arg[n],arg[0])
          return false
        end
      end
      if not _v then
        _v = GetParameter(argt,i,"c","console")
        -- console parameter already processed
      end
      if not _v then
        _v = GetParameter(argt,i,"q","quiet")
        if _v then verbose=v_quiet
          addgsarg("-q") -- -q implies also quiet Ghostscript
        end
      end
      if not _v then
        _v = GetParameter(argt,i,"v","verbose")
        if _v then verbose=v_verbose
          if console then console:Show() end -- -v implies -c
        end
      end
      if not _v then
        _v,_i = GetParameterValue(argt,i,"l","lua")
        -- lua parameter already processed -- check only for bad usage
        if _v then
          if i>0 then
            error(_T("Only one wxLua script can be run -- superfluous: ") .. arg[i]
            .. _T(" parameter.") ..
            _T("\nUse -h or --help option for usage.\n"))
          end
          assert(i==-1,"Assert failed -- parameter passing error")
        end
      end
      if not _v then
        _v = GetParameter(argt,i,"n","new")
        if _v then force_open=true end
      end
      if not _v then
        _v,_i = GetParameterValue(argt,i,"g","gsdll")
        if _v then
          if gsargs.dllloc~="" then
            print_message(_T("Warning -- parameter: ") .. argt[i] .. _T(" overrides previous value.\n"))
          end
          gsargs.dllloc=_v
        end
      end
      if not _v then
        _v,_i = GetParameterValue(argt,i,"i","gslib")
        if _v then table.insert(gsargs.libs,_v) end
      end
      if not _v then
        _v,_i = GetParameterValue(argt,i,"s","gsset")
        if _v then addgsarg("-s".._v)
          if _v:find("INPUT[=#]") then psf_name=_v:match("INPUT[=#](.+)") end
        end
      end
      if not _v then
        _v,_i = GetParameterValue(argt,i,"d","gsdef")
        if _v then addgsarg("-d".._v) end
      end
      if not _v then
        _v,_i = GetParameterValue(argt,i,"p","ps")
        if _v then table.insert(gsargs.progs,_v) end
      end
      if not _v then
        if not argt[i]:match("^%-") then
          _v=argt[i] table.insert(gsargs.progs, _v)
        end
      end
      if not _v then
        error(_T("Unrecognized option: ") .. argt[i] ..
          _T("\nUse -h or --help option for usage.\n"))
      end
      i=i+1+_i
    until i > #argt
    -- and try to find name of file to be opened
    -- (it is used for window title, and refresh mechanism
    if psf_name then gsargs.psf_dir, gsargs.psf_name = PSFName(psf_name) end
  end
  return true
end

function FixGSPaths(gsargs)
  local libloc, gslib, psvlib = gsargs.libloc, gsargs.gslib, gsargs.psvlib
  local libstr, sep, fname = "", ":", wx.wxFileName()
  if wx.__WXMSW__ or wx.__WXOS2__ then  sep=";"
  elseif wx.__WXMAC__ then sep="," end

  if gsargs.dllloc=="" and os.getenv("GS_DLL") then
    gsargs.dllloc=os.getenv("GS_DLL") end
  if gsargs.fontloc=="" and os.getenv("GS_FONTS") then
    gsargs.fontloc=os.getenv("GS_FONTS") end

  if gslib=="" then
    if gsargs.dllloc~="" then
      fname:Assign(gsargs.dllloc)
      fname:RemoveDir(fname:GetDirCount()-1) fname:AppendDir("lib")
      fname:SetName("gs_il2_e") fname:SetExt("ps")
      if fname:FileExists() then gslib = PSFName(fname:GetFullPath()) end
      fname:Assign(gsargs.dllloc)
      fname:RemoveDir(fname:GetDirCount()-1)
      fname:AppendDir("Resource") fname:AppendDir("Init")
      fname:SetName("gs_init") fname:SetExt("ps")
      if fname:FileExists() then
        if gslib=="" then gslib = PSFName(fname:GetFullPath())
        else gslib = gslib .. sep .. PSFName(fname:GetFullPath()) end
      end
    end
  end
  if gslib=="" then gslib="%rom%lib/" .. sep .. "%rom%Resource/Init" end


  if psvlib=="" then
    for i,v in ipairs(gsargs.progs) do
      fname:Assign(v)
      if fname:FileExists() then
        if fname:IsAbsolute() then psvlib = PSFName(fname:GetFullPath()) end
      else
        fname:Assign(wx.wxFileName(arg[0]):GetPath(wx.wxPATH_GET_VOLUME),v)
        if fname:FileExists() then psvlib = PSFName(fname:GetFullPath()) end
      end
    end
  end

  for i,v in ipairs(gsargs.libs) do
    if libstr~="" then libstr=libstr..sep..v else libstr=v end
  end
  if libstr=="" and libloc~="" then libstr=libloc end

  if gslib~="" and not libstr:find(gslib,1,true) then
    if libstr~="" then libstr=gslib..sep..libstr else libstr=gslib end
  end
  if psvlib~="" and not libstr:find(psvlib,1,true) then
    if libstr~="" then libstr=libstr..sep..psvlib else libstr=psvlib end
  end

  if libstr=="" and os.getenv("GS_LIB") then libstr=os.getenv("GS_LIB") end

  gsargs.libloc, gsargs.gslib, gsargs.psvlib = libstr, gslib, psvlib

  -- add default parameters at begining
  if #gsargs.cmd_pars==0 then gsargs.cmd_pars = PSV_DftGsPars end
  for i,v in ipairs(gsargs.cmd_pars) do table.insert(gsargs.args,i,v) end
  -- and PS programs at the end
  for i,v in ipairs(gsargs.progs) do table.insert(gsargs.args,v) end
end


function SetLocale(lang)
  local progdir=wx.wxFileName(arg[0]):GetPath(wx.wxPATH_GET_VOLUME)
  if progdir=="" then progdir="." end
  gsobj.locale=wx.wxLocale(lang)
  os.setlocale("C","numeric")
  if gsobj.locale:IsOk() then
    gsobj.locale.AddCatalogLookupPathPrefix(progdir)
    gsobj.locale:AddCatalog("psv") -- locale `domain'
  end
end

function PrepareLocale()
  local lang=wx.wxLANGUAGE_DEFAULT
  if psvpars.language~="" then
    local langinf=wx.wxLocale.FindLanguageInfo(psvpars.language)
    if langinf then lang=langinf.Language end
  end
  SetLocale(lang)
--  trans=io.open("trans.txt","a")
  function _T(str)
--    trans:write("msgid: \""..str.."\"\n")
    return wx.wxGetTranslation(str)
  end	
  PS_VIEW_VERSION_STRING=string.format(_T("%s, version  %g"), PS_VIEW_NAME, PS_VIEW_VERSION)
end

function CreateInstanceChecker()
  local checker={}
  function checker:Create()
    local tname="." .. PS_VIEW_NAME
    if wx.__WXMSW__ then tname="psview" end -- for Vista (?)
    -- wx.wxFileName.GetTempDir() -- not implemented in wxLua
    -- os.tmpname() -- gives bad result under MSW
    local fname=wx.wxFileName()
    fname:AssignTempFileName(tname)
    if fname:IsOk() then
      wx.wxRemoveFile(fname:GetFullPath())
    else return false end
    fname:AssignDir(fname:GetPath(wx.wxPATH_GET_VOLUME))
    fname:AppendDir(tname)
    if not fname:DirExists() then
      if not fname:Mkdir() then return false end
    end
    self.dname=wx.wxFileName(fname)
    fname:SetName(tname .. MakeNameHash()) fname:SetExt("lock")
    self.fname=wx.wxFileName(fname)
    self.created=false self.time=nil
  end
--
  function checker:SetTime()
    local ok,modtime=self.fname:GetTimes()
    if ok then self.time=modtime end
  end
  function checker:CheckTime()
    local ok,modtime=self.fname:GetTimes()
    if modtime:IsLaterThan(self.time) then
      if self.fname:GetSize():ToULong()<2 then 
        -- signal active instance
        self:CreateLock()
      else self.time=modtime end 
      return true
    else return false end
  end
  function checker:CreateLock()
    self:MakeLock(tostring(wx.wxGetProcessId()))
    self:SetTime() self.created=true
  end
  function checker:MakeLock(cont)
    local file=wx.wxFile(self.fname:GetFullPath(),wx.wxFile.write)
    if file:IsOpened() then	
      file:Write(cont) file:Close()	
    end
  end
  function checker:UpdateLock()
    self.fname:Touch()
    self:SetTime()
  end
--
  function checker:IsAnotherInstance()
    if not self.dname or not self.fname then return false end
    if not self.dname:DirExists() then self.dname:Mkdir() end
    if self.fname:FileExists() then
      print_debug("SIZE: ", self.fname:GetSize():ToULong())
      if self.fname:GetSize():ToULong()<2 then 
        -- unactive instance found (= no active instance)
        self:CreateLock() return false 
      end
      self:UpdateLock() return true
    else
      self:CreateLock() return false
    end	
  end
--
  function checker:IsLockUpdated()
    if not self.dname or not self.fname then return false end
    if not self.dname:DirExists() then self.dname:Mkdir() end
    if self.fname:FileExists() then
      return self:CheckTime()
    else
      self:CreateLock() return true	
    end	
  end
--
  function checker:Destroy(quit)
    if not self.dname or not self.fname then return false end
    if not self.dname:DirExists() then return false end
    if self.created and self.fname:FileExists() then
      wx.wxRemoveFile(self.fname:GetFullPath())
    end	
    local old,mod=wx.wxDateTime(os.time())
    old:Subtract(wx.wxDateSpan.Days(7))
    local dir=wx.wxDir(self.dname:GetPath(wx.wxPATH_GET_VOLUME))
    local f,filen=dir:GetFirst()
    local fname=wx.wxFileName(dir:GetName(),filen)
    while f do
      ok,mod=fname:GetTimes()
      if mod:IsEarlierThan(old) then wx.wxRemoveFile(fname:GetFullPath()) end
      f,filen=dir:GetNext() fname:SetFullName(filen)
    end	
    if quit and not dir:HasFiles() then wx.wxRmdir(dir:GetName()) end	
    self.dname=nil self.fname=nil self.time=nil
    return true
  end
--
  checker:Create()
  return checker
end

function MakeNameHash()
  local str = PS_VIEW_NAME .. wx.wxGetUserId() .. gsargs.psf_dir .. gsargs.psf_name
  local hash,hasht = 231172,{}
  for i,v in ipairs{str:byte(1,#str)} do hash = hash + 8^(i%13)*v end
  while hash>1 do table.insert(hasht,65+hash%26%26) hash=math.floor(hash/26) end
  return string.char(unpack(hasht))
end

function ConfigGetParameters()
  gsobj.config:SetPath("/PSV_Parameters")
  local _, _cmd  = gsobj.config:Read("cmdpars", "")
  local _, _lang = gsobj.config:Read("language", "")
  if #gsargs.cmd_pars==0  and _cmd  then
    for i in string.gmatch(_cmd,"%S+") do table.insert(gsargs.cmd_pars,i) end
  end
  if psvpars.language==""  and _lang then psvpars.language = _lang end
end

function ConfigGetPaths(gsargs)
  gsobj.config:SetPath("/GhostscriptPaths")
  local _, _gsdll  = gsobj.config:Read("dll", "")
  local _, _gslibs = gsobj.config:Read("libs", "")
  local _, _gsfont = gsobj.config:Read("font", "")
  local _, _gslib  = gsobj.config:Read("gslib", "")
  local _, _psvlib = gsobj.config:Read("psvlib", "")
  if gsargs.dllloc==""  and _gsdll  then gsargs.dllloc =_gsdll  end
  if gsargs.libloc==""  and _gslibs then gsargs.libloc =_gslibs end
  if gsargs.fontloc=="" and _gsfont then gsargs.fontloc=_gsfont end
  if gsargs.gslib==""   and _gslib  then gsargs.gslib  =_gslib  end
  if gsargs.psvlib==""  and _psvlib then gsargs.psvlib =_psvlib end
end

function ConfigSavePaths(gsargs)
  gsobj.config:SetPath("/GhostscriptPaths")
  gsobj.config:Write("dll",    gsargs.dllloc)
  gsobj.config:Write("libs",   gsargs.libloc)
  gsobj.config:Write("font",   gsargs.fontloc)
  gsobj.config:Write("gslib",  gsargs.gslib)
  gsobj.config:Write("psvlib", gsargs.psvlib)
end

function ConfigRestoreFramePosition(window, windowName)
  gsobj.config:SetPath("/"..windowName)
  local _, s = gsobj.config:Read("s", -1)
  local _, x = gsobj.config:Read("x", -1)
  local _, y = gsobj.config:Read("y", -1)
  local _, w = gsobj.config:Read("w", -1)
  local _, h = gsobj.config:Read("h", -1)
  if s ~= -1 then
    local cX, cY, cW, cH = wx.wxClientDisplayRect()
    if x < cX then x = cX end
    if y < cY then y = cY end
    if w > cW then w = cW end
    if h > cH then h = cH end
    window:SetSize(x, y, w, h)
  end
  if s == 1 then window:Maximize(true) end
end

function ConfigSaveFramePosition(window, windowName)
  gsobj.config:SetPath("/"..windowName)
  local s = 0
  local w, h = window:GetSizeWH()
  local x, y = window:GetPositionXY()

  if window:IsMaximized() then s = 1
  elseif window:IsIconized() then s = 2 end
  gsobj.config:Write("s", s)
  if s == 0 then
    gsobj.config:Write("x", x)
    gsobj.config:Write("y", y)
    gsobj.config:Write("w", w)
    gsobj.config:Write("h", h)
  end
end

function Main()
  wxapp = wx.wxGetApp()
  console=wxapp:GetTopWindow() -- or `nil' if console not created
  wxapp:SetAppName("psv")

  gsobj.config = wx.wxFileConfig() -- default setting are very nice
  ConfigGetParameters()
  PrepareLocale()

  if not ParseCommandLine(arg) then return true end

  if #gsargs.progs==0 then
    error(_T("No PostScript programe give in commandline, I don't know what to do -- quiting.\n"))
  end

  gsobj.instancechecker = CreateInstanceChecker()
  if not gsobj.instancechecker then
    error(_T("Unable to create instance checker, check lock in temp directory -- quiting.\n"))
  end
  if gsobj.instancechecker:IsAnotherInstance() and not force_open then
    print_message(_T("Another instance of PS_View is running -- quiting.\n"))
    gsobj.instancechecker:MakeLock('0') -- try if instance is dead
    gsobj.instancechecker:Destroy()
    return true
  elseif force_open then gsobj.instancechecker:CreateLock() end


  ConfigGetPaths(gsargs)

  -- create the wxFrame window
  frame = wx.wxFrame( wx.NULL,  -- no parent for toplevel windows
    wx.wxID_ANY,                -- don't need a wxWindow ID
    PS_VIEW_NAME,               -- caption on the frame
    wx.wxDefaultPosition,       -- let system place the frame
    wx.wxDefaultSize,           -- set the size of the frame
    wx.wxDEFAULT_FRAME_STYLE )  -- use default frame styles

  ConfigRestoreFramePosition(frame, "MainWindow")
  frame:SetIcons(iconimg)

  if console then
    InitializeConsole()
    ConfigRestoreFramePosition(console, "ConsoleWindow")
    console:SetIcons(icontxt)
    wxapp:SetTopWindow(frame)
  end

  SetPSTitle(gsargs.psf_name)

  FixGSPaths(gsargs)

  InitializeGS()
  StartGS()

  ConnectEvents ()

  -- show the frame window
  frame:Show(true)
  gswin.gswindow:SetFocus()

  wx.wxWakeUpIdle() -- probably not needed, but inserted for sure
end


Main()
