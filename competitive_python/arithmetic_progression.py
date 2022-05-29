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
    Arithmetic Progression
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
  #
  #
  #
  print("simple sum {}".format(sum_arithmetic_progression(100)))
  #
  #
  #
  qt_1_pt="""
  Dado o conjunto dos números naturais, não nulos, qual é a soma dos seus 200 primeiros números pares?
  """
  qt_1_en="""
  Given the set of nonzero natural numbers, what is the sum of your first 200 even numbers?
  """
  qt_1_explan_en="""
  # s=range(1,200,2) # list with first 200 even numbers
  """
  print(f'witch is the sum of first 200 even numbers {s}'.format(witch_is_the_sum_of_term(range(2,401,2))))
  
  qt_2_pt="""
  Com o intuito de construir um jogo novo, foram colocados sobre um tabuleiro de xadrez grãos de arroz da seguinte maneira: 
  na primeira casa, foram colocados 5 grãos; na segunda, 10; na terceira, 15; e assim por diante.
  Quantos grãos de arroz foram usados nesse tabuleiro?
  """
  qt_2_en="""
  grains of rice were placed on a chessboard as follows: in the first square, 5 grains were placed; in the second, 10;
  in the third, 15; and so on.
  How many grains of rice were used in this tray?
  """
  qt_2_explan_en="""
  # 5 rice grains in the first
  # HACK 65*5 count the number of unit positions (black, white) 
  # hack is bcz 5+5...so for each square add 5 so 65*5 is 64 squares. you can check it in the line 21
  # 5 is the number of steps
  """
  print(f'witch is the sum of rice grains {s}'.format(witch_is_the_sum_of_term(range(5,65*5,5))))

  qt_3_pt="""
  (PUC/RJ – 2008) A soma de todos os números naturais ímpares de 3 algarismos é:
  """
  qt_3_en="""
  (PUC/RJ – 2008) The sum of all odd 3-digit natural numbers is:
  """
  print(f'witch is the sum of all odd 3-digit {}'.format(witch_is_the_sum_of_term(range(101,1000,2))))

if __name__ == '__main__':
  callers()
