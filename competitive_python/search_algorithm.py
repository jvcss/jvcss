from math import sqrt
"""
search sorted list to determine if the value is in the list
"""
def bisectorial_search(List, match):
  def bisect_search_helper(List, match,low,high):
    if high == low:
      return List[low] == match
    mid = (low + high)//2
    if List[mid] == match:
      return True
    elif List[mid]>match:
      if low==mid:#nothing left to search
        return False
      else:
        return bisect_search_helper(List, match, low, mid-1)
    else:
        return bisect_search_helper(List, match, mid+1, high)
  if len(List) == 0:
    return False
  else:
    return bisect_search_helper(List, match, 0, len(List)-1)

"""
search if this NUM is prime
"""
def is_prime(num):
  if num == 0 or num == 1 or num%2 == 0 or num%3 == 0:
    return False
  if num == 2 or num == 3:
    return True
  for items in range(5, int(sqrt(num))+1):
    if num%items or num%(items+2)==0:
      False
  return True

def callers():
  """
  #extremelly large integer list 
  """
  Range = range(0,999999999999999999)
  #print(len(Range) )
  #print(Range[-1])
  print("Can I find in this 999.999.999.999.999.999 large array? {}".format(bisectorial_search(Range, 9999999999999999991)))#false

  print("if this unbelievably large number is prime {}".format(is_prime(999999999999999999)))

if __name__ == '__main__':
  callers()

