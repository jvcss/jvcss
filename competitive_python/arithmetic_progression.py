"""
# Big O (1) complexity 1
# return adding together all the integers
#
# A.P = Arithmetic progression
#  a sequence of numbers in order, 
# in which the difference between any two consecutive numbers 
# is a constant value
# equals the sum of all itens the array
#
# SEJA GAUSS
# somar todos os números de 1 a 100
"""
def sum_arithmetic_progression(number):
    return (number)*(number+1)//2

"""
Dado o conjunto dos números naturais, não nulos, qual é a soma dos seus 200 primeiros números pares?
"""
"""
Given the set of nonzero natural numbers, what is the sum of your first 200 even numbers?
"""
def witch_is_the_sum_of_term(arr):
    
    #print(f'last_term {arr[-1:][0]}') #LAST TERM EASY ACCESS
    num_terms = len(arr)# knows the length
    #print(f'num_terms = {num_terms}')
    
    ratio = arr[1]-arr[0] # knows the ratio
    last_term = arr[0] + ((num_terms-1)*ratio) #calculus LAST TERM
    
    sum_n_terms = (num_terms*(arr[0] + last_term))//2
    
    return sum_n_terms


"""
CALL ALL EXERCISES
"""
def callers():
  """
  # witch_is_the_sum_of_term
  #
  # s=range(1,200,2) # list with first 200 even numbers
  """
  s = witch_is_the_sum_of_term(range(2,401,2))#first even interval
  print(f'witch is the sum of term {s}')
  
  #
  #
  #
  print("simple sum {}".format(sum_arithmetic_progression(100)))

if __name__ == '__main__':
  callers()
