#!/usr/bin/env ruby
class CircuitBreaker
  # def blown?
  #   false
  # end

  # def add_event(succeeded, time=Time.now)
  # end
end

# FastBlow
# - Trips when {threshold} failures occur in a row regardless of time between
#   attempts
# - Resets fail count if a successful operation occurs
# - Stays tripped until manually reset
class FastBlow
  attr_reader :threshold, :fail_count
  def initialize(threshold) # could add a self-resetting expiration here?
    @threshold = threshold
    @fail_count = 0
  end

  def add_event(succeeded)
    if succeeded
      @fail_count = 0
    else
      @fail_count += 1
    end
  end

  def blown?
    fail_count >= threshold
  end

  def reset!
    @fail_count = 0
  end
end

# SlowBlow

# - Trips if {threshold} failures occur in the last {expiration_time}
# - Self-resets if failures in the duration drops below threshold
class SlowBlow
  attr_reader :threshold, :expiration
  def initialize(threshold, expiration)
    @threshold = threshold
    @expiration = expiration
    @events = []
    @blown = false
  end

  def add(succeeded, time=time.now)
    cutoff = time - expiration
    @events.pop while !@events.empty? && @events.last < cutoff
    if !succeeded
      @events.unshift time
    end
  end

  def blown?
    @events.size >= threshold
  end

  def reset!
    @events.clear
  end
end
