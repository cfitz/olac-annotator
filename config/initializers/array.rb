class Array
  def diff(other)
    result = dup
    other.each{|e| result.include?(e) ? result.delete(e) : result.push(e) }
    result
  end 
end