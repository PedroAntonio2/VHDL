# Define the mapping of characters to binary codes
char_to_binary = {
   'A': '01000001',
   'B': '01000010',
   'C': '01000011',
   'D': '01000100',
   'E': '01000101',
   'F': '01000110',
   'G': '01000111',
   'H': '01001000',
   'I': '01001001',
   'J': '01001010',
   'K': '01001011',
   'L': '01001100',
   'M': '01001101',
   'N': '01001110',
   'O': '01001111',
   'P': '01010000',
   'Q': '01010001',
   'R': '01010010',
   'S': '01010011',
   'T': '01010100',
   'U': '01010101',
   'V': '01010110',
   'W': '01010111',
   'X': '01011000',
   'Y': '01011001',
   'Z': '01011010',
  ':': '00111010',
   '0': '00110000',
  '1': '00110001',
  '2': '00110010',
  '3': '00110011',
  '4': '00110100',
  '5': '00110101',
  '6': '00110110',
  '7': '00110111',
  '8': '00111000',
  '9': '00111001',
  ' ': '00010000' 
}

def generate_vhdl(text):
   vhdl_code = ""
   for i, char in enumerate(text):
       binary_code = char_to_binary[char]
       vhdl_code += f"""WHEN WriteData{i+1} =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "{binary_code}"; --'{char}'
nx_state <= WriteData{i+2};
"""
   return vhdl_code

# Test the function
if __name__ == '__main__':
   print(generate_vhdl("FASE1: OK"))
