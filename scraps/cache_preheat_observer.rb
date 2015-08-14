#!/usr/bin/env ruby

# cache_preheat_observer.rb

# Rather tortuous example showing that notify_observers is synchronous, making
# it suitable for use in precaching on access, meaning you can try to get
# something from the Cache, and if it needs preheating the notification process
# will block the get until the preheat is done, and then allow the get to return
# items that were preheated.

# The code here seems cluttered because of all the loggingc messages; this is so
# the output will be clean. Run this ruby file to see the method call trace so
# you can see that Cache#get on an empty cache triggers Model.preheat, preheat
# does its thing, and then Cache#get accesses and returns the preheated values
# without ever requiring the client to check for expiration or initialization.

# This on-demand preheating means that we can expire and preheat the cache
# willy-nilly, without Cache clients having to care about checking for
# expiration and managing precaching, etc. The Model class DOES have to DO the
# preheating, because only the Model can create new items--the Cache class
# should not know how to create new Models.

# Note, of course, that Leaver's Law applies: everything this cache does FOR you
# this cache also does TO you: if preheating takes a long time, then the first
# sucker to try to get ANYTHING from the cache is going to have to wait while
# the cache preheats.

# Code to expire the cache and explicitly demand preheating are omitted from
# this example because it's already too long.

require 'observer'

srand 42

# ----------------------------------------------------------------------
# Cache Class
#
# get and set, but also will notify observers if the cache is accessed while
# empty. This allows an observer to intercept the access and precache some
# things before the access begins
class Cache
  include Observable

  @@cache = {}

  def get items=[]
    if @@cache.empty?
      changed
      notify_observers
    end
    items.each_with_object({})  do |item, hash|
      if @@cache.key?(item)
        hash[item] = @@cache[item]
      end
    end
  end

  def set items={}
    items.each do |key, value|
      @@cache[key] = value
    end
  end
end

# ----------------------------------------------------------------------
# Model Class
#
# Arbitrary model. The first access of cache creates the cache and attaches the
# Model class as an Observer. Model.find(ids) will get as many items as possible
# from the cache first, and then use its create method to create the
# rest. Before merging the cached and created items, the created items are
# stored in the cache.
#
# Model.on_cache_expired is a poor man's "event handler"; it is the notify
# method given to the Cache when attaching as an Observer. All it does is call
# Model.preheat, which creates and caches items for ids 1..10.
#
# self.cache_class is a conceit to allow LoggingModel to inherit from Model, and
# have Model.cache create a LoggingCache instead of a Cache
class Model
  def self.cache
    @cache ||= cache_class.new.tap {|c| c.add_observer self, :on_cache_expired }
  end

  def self.find(ids=[])
    cached_items = cache.get ids
    uncached_ids = ids - cached_items.keys
    new_items = uncached_ids.each_with_object({}) do |id, hash|
      hash[id] = create id
    end
    cache.set new_items
    cached_items.merge new_items
  end

  def self.create(id)
    rand 100
  end

  def self.on_cache_expired
    preheat
  end

  def self.preheat
    preheated_items = (1..10).each_with_object({}) do |id, hash|
      hash[id] = create id
    end
    cache.set preheated_items
  end

  # Override this in child classes. We're not using a proper Factory here.
  def self.cache_class
    Cache
  end
end

# ======================================================================
# LOGGING NOISE STARTS HERE

# ----------------------------------------------------------------------
# LOGGING METHODS
#
# These write to $stdout then immediately flush it so the message is written
# before any other code can execute, potentially misordering the output.
$indent = 0

def log_entry msg=''
  $indent += 1
  log msg
end

def log_exit msg=''
  log msg
  $indent -= 1
end

def log msg=''
  $stdout.puts '%s%s' % ['  ' * $indent, msg]
  $stdout.flush
end
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# LOGGING CLASSES

# These classes just wrap the Model and Cache classes so that method calls can
# be logged appropriately but leave the Model and Cache classes clean of logging
# noise.

# ----------------------------------------------------------------------
# LoggingCache

# Wrapper around Cache class that logs the call trace
class LoggingCache < Cache
  def get items=[]
    log_entry "-> LoggingCache#get called on items: #{items.inspect}"
    ret = super
    log_exit "<- LoggingCache#get returning #{ret.inspect}"
    ret
  end

  def set items={}
    log_entry "-> LoggingCache#set called on: #{items.inspect}"
    super
    log_exit "<- LoggingCache#set returning"
  end
end

# ----------------------------------------------------------------------
# LoggingModel

# Wrapper around Model class that logs the call trace
class LoggingModel < Model
  def self.cache
    log_entry "-> Model.cache called"
    unless @cache
      log("Model.cache: NEW CACHE. Attaching observer")
    end
    ret = super
    # @@cache ||= LoggingCache.new.tap do |c|
    #   log "Model.cache: NEW CACHE. Attaching observer"
    #   c.add_observer self, :on_cache_expired
    # end
    log_exit "<- Model.cache returning #{@cache.inspect}"
    ret
  end

  def self.find(ids=[])
    log_entry "-> Model.find called on ids #{ids.inspect}"
    ret = super
    log_exit "<- Model.find returning #{ret.inspect}"
    ret
  end

  def self.create(id)
    log_entry "-> Model.create called on id #{id}"
    ret = super
    log_exit "<- Model.create returning #{ret}"
    ret
  end

  def self.on_cache_expired
    log_entry "-> Model.on_cache_expired called"
    super
    log_exit "<- Model.on_cache_expired exiting"
  end

  def self.preheat
    log_entry "-> Model.preheat called"
    super
    log_exit "<- Model.preheat exiting"
  end

  def self.cache_class
    LoggingCache
  end
end

# ======================================================================
# MAIN PROGRAM
# ----------------------------------------------------------------------

log "main: inspecting Model.cache:"
log LoggingModel.cache.inspect
log "main: done inspecting Model.cache"

log "main: Finding models (1..5)"
models = LoggingModel.find (1..5).to_a
log "main: models found:"
models.each do |key, value|
  log "main:   - #{key}: #{value}"
end
log "main: Done finding models 1..5."
log

log "main: Finding models (3..7)"
models = LoggingModel.find (3..7).to_a
log "main: models found:"
models.each do |key, value|
  log "main:   - #{key}: #{value}"
end
log "main: Done finding models 3..7."
log
