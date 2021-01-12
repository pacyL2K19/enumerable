# rubocop:disable all 
module Enumerable
  def my_each
    if block_given?
      i = 0
      while i < size
        yield self[i]
        i += 1
      end
      self
    else
      to_enum(__method__)
    end
  end

  def my_each_with_index
    if block_given?
      i = 0
      while i < size
        yield(self[i], i)
        i += 1
      end
      self
    else
      to_enum(__method__)
    end
  end

  def my_select
    if block_given?
      i = 0
      arr = []
      while i < size
        arr << self[i] if yield self[i]
        i += 1
      end
      arr
    else
      to_enum(__method__)
    end
  end

  def my_all?(word = nil)
    if block_given?
      i = 0
      j = 0
      while i < size
        yield self[i]
        i += 1
      end

      each do |element|
        j += 1 if yield(element) == false or yield(element).nil?
      end
      j.zero? ? true : false

    else
      i = 0
      j = 0

      while i < size
        self[i]
        i += 1
      end
      if size.zero?
        true
      elsif word.instance_of?(Regexp)
        each do |element|
          j += 1 if element =~ word
        end
        j == length

      elsif word == Numeric

        each do |element|
          j += 1 if element.class <= word
        end
        j == length
      elsif !word.nil?
        i = 0
        while i < size
          j += 1 if self[i - 1] == self[i]
          i += 1
        end
        k = 0
        each do |element|
          k += 1 if element.instance_of?(word)
        end

        each do |element|
          k += 1 if element == word
        end

        k == length

      else
        each do |element|
          j += 1 if [false, nil].include?(element)
        end
        j.zero? ? true : false
      end
    end
  end

  def my_any?(word = nil)
    if block_given?
      i = 0
      j = 0
      while i < size
        yield self[i]
        i += 1
      end

      each do |element|
        j += 1 if yield element
      end
      j.positive? and j <= size
    else
      i = 0
      j = 0
      while i < size
        self[i]
        i += 1
      end
      if size.zero?
        false
      elsif word.instance_of?(Regexp)

        each do |element|
          j += 1 if element =~ word
        end
        j.positive? and j <= length

      elsif !word.nil?
        i = 0
        k = 0
        while i < size
          k += 1 if word == self[i]
          i += 1
        end

        each do |element|
          k += 1 if element.instance_of?(word)
        end
        k.positive? ? true : false

      elsif word == Numeric
        each do |element|
          j += 1 if element.class <= word
        end

        j.positive? and j <= length

      else
        k = 0
        each do |element|
          k += 1 if [false, nil, false, nil, false, nil].include?(element)
        end
        k != size

      end

    end
  end

  def my_none?(word = nil)
    if block_given?
      i = 0
      while i < size
        yield self[i]
        i += 1
      end
      j = 0
      my_each do |element|
        j += 1 if yield element
      end
      j.zero? ? true : false

    else
      i = 0
      j = 0
      while i < size
        self[i]
        i += 1
      end
      if size.zero?
        true
      elsif word.instance_of?(Regexp)

        my_each do |element|
          j += 1 if element =~ word
        end

        j.zero? ? true : false

      elsif !word.nil?
        if word == Numeric
          each do |element|
            j += 1 if element.class <= word
          end

          j.positive? ? false : true
        else
          i = 0
          k = 0
          each do |element|
            k += 1 if element == word
          end
          while i < size
            k += 1 if self[i].instance_of?(word)
            i += 1
          end
          k.zero? ? true : false

        end

      else
        j = 0
        my_each do |e|
          j += 1 if e == true
        end
        j.zero? ? true : false
      end
    end
  end

  def my_count(val = nil)
    if block_given?
      j = 0
      my_each do |element|
        j += 1 if yield element
      end
      j
    elsif val.class != NilClass

      i = 0

      each do |el|
        i += 1 if el == val
      end
      i
    else
      my_each do |count|
        count += 1
      end
      count
    end
  end

  def my_map(proc_argument = nil)
    if block_given?
      arr = []
      each do |element|
        current = yield element
        arr << current
      end
      arr
    elsif !proc_argument.nil?
      arr = []
      each do |element|
        current = proc_argument.call(element)
        arr << current
      end
      arr
    else
      to_enum(__method__)
    end
  end

  def my_inject(*param)
    arr = []
    i = 0
    each do |element|
      arr << element
    end

    if block_given?
      acc = param[0]
      result = yield(arr[0], arr[1])

      arr.my_each do |e|
        result = yield(result, e) if e.instance_of?(String)

        result = yield(result, e) if i > 1
        i += 1
      end

      result *= acc if acc.class <= Numeric

    else

      if param.length == 1
        acc = param[0]
        result = arr[0]
        arr[1..-1].my_each do |el|
          result = result.send(acc, el)
        end
      end
      if param.length == 2
        result = param[0]
        acc = param[1]
        arr.my_each do |el|
          result = result.send(acc, el)
        end
      end
    end
    result
  end
end
