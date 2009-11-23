# Created a method subdivide which will take the values of an array and return an array of arrays each one of size 'n'
# Default size for n is 10
class Array
  def subdivide(n = 10)
    if n <= 0 || n >= self.size
      return [self]
    end
    result = []
    max_subarray_size = n - 1

    new_array = self.clone
    while new_array.size > 0
      result << new_array.slice!(0..max_subarray_size)
    end

    result
  end
end
