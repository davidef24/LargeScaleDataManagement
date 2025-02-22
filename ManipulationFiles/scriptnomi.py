import re

def extract_non_ascii(input_file, output_file):
    non_ascii_chars = set()
    
    with open(input_file, 'r', encoding='utf-8') as infile:
        for line in infile:
            non_ascii_chars.update(re.findall(r'[^\x00-\x7F]', line))
    
    with open(output_file, 'w', encoding='utf-8') as outfile:
        outfile.write(''.join(sorted(non_ascii_chars)))

# Example usage
extract_non_ascii('nonascii.txt', 'non_ascii_chars.txt')