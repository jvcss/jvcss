def OrderRoyalRoman(reis):
  def romanToInt(s):
    """
    :type s: str
    :rtype: int
    """
    roman = {'I':1,'V':5,'X':10,'L':50,'C':100,'D':500,'M':1000,'IV':4,'IX':9,'XL':40,'XC':90,'CD':400,'CM':900}
    i = 0
    num = 0
    while i < len(s):
      if i+1<len(s) and s[i:i+2] in roman:
        num+=roman[s[i:i+2]]
        i+=2
      else:
        #print(i)
        num+=roman[s[i]]
        i+=1
    return num
  def intToRoman(number):
    num = [1, 4, 5, 9, 10, 40, 50, 90,100, 400, 500, 900, 1000]
    sym = ["I", "IV", "V", "IX", "X", "XL","L", "XC", "C", "CD", "D", "CM", "M"]
    i = 12
    roman = ''
    while number:
      div = number // num[i]
      number %= num[i]

      while div:
        #print(sym[i], end = "")
        roman += sym[i]
        div -= 1
      i -= 1
    return roman
  #reis = ['Joao Victor IV', 'Ana II', 'Ana IV', 'Ana V','Ana CX','Abc V']
  listas = []
  out_list = []
  for each in reis:
    each = each[::-1]
    rev_gen = each.split()
    t_gen = rev_gen[0][::-1]
    t_name = ' '.join(rev_gen[1:])[::-1]
    #print(t_gen)
    #print(romanToInt(t_gen))
    #intRom = intToRoman(romanToInt(t_gen))
    #print(intRom)
    #print(t_name)
    rei_comp = [t_name, romanToInt(t_gen)]

    #l_rei_comp = [t_name, t_gen]

    listas.append(rei_comp)

  for cada in sorted(listas):
    #print(intToRoman(cada[1]))
    cada[1] = intToRoman(cada[1])
    out_list.append(' '.join(cada))
  print(out_list)
  return out_list



def callers():
  OrderRoyalRoman(['Joao Victor IV', 'Ana II', 'Ana IV', 'Ana V','Ana CX','Abc V'])

if __name__ == '__main__':
  callers()
