# Oh say what is truthiness?

# Sometimes you need to evaluate a response for truthiness, but you
# don't want to spec against the specific value of true. Saying
# x.should be_true is the same thing as saying (!!x).should == true
class BeTrue
  def initialize
  end

  def matches?(actual)
    true == !!actual
  end

  def failure_message
    "expected the expression to evaluate as true in a boolean context, but it didn't"
  end

  def negative_failure_message
    "expected the expression to not evaluate as true in a boolean context, but it did"
  end
end

# Succeeds if actual is truthy.
def be_true
  BeTrue.new
end

