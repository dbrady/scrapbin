#!/usr/bin/env ruby
# max_open_playlist - Resize the Winamp Open Playlist window to fullscreen ~(1400x850)
require 'dl/import'
require 'dl/struct'
require "timeout"
require 'Win32API'

HWND_TOPMOST = -1
WIN32_TRUE = -1 # windows "true" condition

setWindowPos = Win32API.new('user32', 'SetWindowPos', ["P", "P", "I", "I", "I", "I", "I"], "I")

user32 = DL.dlopen("user32")

enum_windows = user32['EnumWindows', 'IPL']
get_class_name = user32['GetClassName', 'ILpI']
get_caption_length = user32['GetWindowTextLengthA' ,'LI' ]    # format here - return value type (Long) followed by parameter types - int in this case -      see http://www.ruby-lang.org/cgi-bin/cvsweb.cgi/~checkout~/ruby/ext/dl/doc/dl.txt?
get_caption = user32['GetWindowTextA', 'iLsL' ] 

buff = " " * 32

enum_windows_proc = DL.callback("ILL") { |hwnd,lparam|
  sleep 0.05
  r,rs = get_class_name.call(hwnd, buff, buff.size)
  
  winclass = rs[1].to_s
  textLength, a = get_caption_length.call(hwnd)
  captionBuffer = " " * (textLength + 1)
  
  t,textCaption = get_caption.call(hwnd, captionBuffer, captionBuffer.size)
  title = textCaption[1].to_s
  
  puts "#{winclass}: #{title}"
  # continue enumeration
  WIN32_TRUE
}
r,rs = enum_windows.call(enum_windows_proc, 0)
DL.remove_callback(enum_windows_proc)
