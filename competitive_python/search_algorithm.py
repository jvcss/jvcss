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

def callers():
  """
  #extremelly large integer list 
  """
  Range = range(0,999999999999999999)
  print(len(Range) -1)
  print(Range[-1])
  print(bisectorial_search(range(1,100000000000), 9999999999999999991))#false

if __name__ == '__main__':
  callers()
  
