#!/usr/bin/env ruby
# max_open_playlist - Resize the Winamp Open Playlist window to fullscreen ~(1400x850)
require 'dl/import'
require 'dl/struct'
require "timeout"
require 'Win32API'

HWND_TOPMOST = -1
setWindowPos = Win32API.new('user32', 'SetWindowPos', ["P", "P", "I", "I", "I", "I", "I"], "I")
#puts setWindowPos

def getWindowHandle(title, winclass = "" )
  user32 = DL.dlopen("user32")

  enum_windows = user32['EnumWindows', 'IPL']
  get_class_name = user32['GetClassName', 'ILpI']
  get_caption_length = user32['GetWindowTextLengthA' ,'LI' ]    # format here - return value type (Long) followed by parameter types - int in this case -      see http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/~checkout~/ruby/ext/dl/doc/dl.txt?
  get_caption = user32['GetWindowTextA', 'iLsL' ] 

  #if winclass != ""
  #    len = winclass.length + 1
  #else
  len = 32
  #end
  buff = " " * len
  classMatch = false
  
  #           puts("getWindowHandle - looking for: " + title.to_s )

  bContinueEnum = -1  # Windows "true" to continue enum_windows.
  found_hwnd = -1
  enum_windows_proc = DL.callback('ILL') {|hwnd,lparam|
    sleep 0.05
    r,rs = get_class_name.call(hwnd, buff, buff.size)
    #              puts "Found window: " + rs[1].to_s

    if winclass != "" then
      if /#{winclass}/ =~ rs[1].to_s
        classMatch = true
      end
    else
      classMatch = true
    end

    if classMatch ==true
      textLength, a = get_caption_length.call(hwnd)
      captionBuffer = " " * (textLength+1)

      t ,  textCaption  = get_caption.call(hwnd, captionBuffer  , textLength+1)    
      #                    puts "Caption =" +  textCaption[1].to_s

      if /#{title}/ =~ textCaption[1].to_s
        # puts "Found Window with correct caption (" + textCaption[1].to_s + " hwnd=" + hwnd.to_s + ")"
        found_hwnd = hwnd
        bContinueEnum = 0 # False, discontinue enum_windows
        #                        return hwnd  # NO!  Don't do a return from the callback
      end
      bContinueEnum
    else
      bContinueEnum
    end
  }
  r,rs = enum_windows.call(enum_windows_proc, 0)
  DL.remove_callback(enum_windows_proc)
  return found_hwnd
end

caption = 'Open Playlist'
hwnd = getWindowHandle(caption)
puts "Couldn't find window with caption #{caption}" if hwnd.zero?
#setWindowPos.call(hwnd, HWND_TOPMOST, 0,0,1440,870,0) unless hwnd.zero?
setWindowPos.call(hwnd, HWND_TOPMOST, 0,0,1680,1020,0) unless hwnd.zero?

